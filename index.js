const fs = require('fs');
const fastify = require('fastify')();
const simpleGit = require('simple-git');
const { v4: uuidv4 } = require('uuid');
const { exec } = require('child_process');

const port = "9000"


// const gameHistoryFilePath = 'gameHistory.json';
// let gameHistory = [];

// // Check if the game history JSON file exists
// if (fs.existsSync(gameHistoryFilePath)) {
//   // Read the game history JSON file and parse it into the gameHistory array
//   const gameHistoryData = fs.readFileSync(gameHistoryFilePath, 'utf8');
//   gameHistory = JSON.parse(gameHistoryData);
//   console.log(gameHistory);
// }
async function runGitPull() {
  const git = simpleGit();

  try {
    await git.pull();
    console.log('Git pull completed successfully.');
  } catch (error) {
    console.error('Error during git pull:', error);
  }
}
async function runNpmInstall() {
  exec('npm install', (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error.message}`);
      return;
    }
    if (stderr) {
      console.error(`stderr: ${stderr}`);
      return;
    }
    console.log(`stdout: ${stdout}`);
    console.log('npm install completed successfully!');
  });
}

// fastify.post('/win', (request, reply) => {
//   console.log(request.body);

//   reply.send({ message: 'Success' });
// });

fastify.post('/win', (req, res) => {
  const { winner, UID, gamePlayed } = req.body;

  // Read the games.json file
  fs.readFile('games.json', 'utf8', (err, data) => {
    if (err) {
      console.error('Error reading games.json:', err);
      return res.sendStatus(500);
    }

    let json = JSON.parse(data);

    // Find the game with the matching UID
    if (json[UID]) {
      const game = {
        date: getCurrentDate(),
        time: getCurrentTime(),
        selectedGame: gamePlayed, // Example value, modify as needed
        winner: winner
      };
      let GameUID = generateGameId();
      // Add the new game to the Games object
      json[UID].Games[GameUID] = game;

      // Update the games.json file
      fs.writeFile('games.json', JSON.stringify(json, null, 2), 'utf8', (err) => {
        if (err) {
          console.error('Error writing to games.json:', err);
          return res.sendStatus(500);
        }

        res.send(json[UID].Games[GameUID]);
      });
    } else {
      console.error('Game not found for UID:', UID);
      res.sendStatus(404);
    }
  });
});

// Utility functions to generate a game ID and get the current date/time
function generateGameId() {
  return uuidv4();
}


function getCurrentDate() {
  // Get the current date in the desired format
  const date = new Date();
  return date.toISOString().split('T')[0];
}

function getCurrentTime() {
  // Get the current time in the desired format
  const date = new Date();
  const hours = date.getHours().toString().padStart(2, '0');
  const minutes = date.getMinutes().toString().padStart(2, '0');
  return `${hours}:${minutes}`;
}

fastify.post('/ServerUpdate', (request, reply) => {
  console.log("Updating");
  runGitPull();
  reply.send({ message: 'Success' });
});

fastify.post('/ServerNpm', (request, reply) => {
  console.log("Updating");
  runNpmInstall();
  reply.send({ message: 'Success' });
});

fastify.post('/score', (request, reply) => {
  console.log(request.body);
  const { UID } = request.body;
  fs.readFile('games.json', 'utf8', (err, data) => {
    if (err) {
      console.error('Error reading games.json:', err);
      return res.sendStatus(500);
    }

  let json = JSON.parse(data);
  let session = json[UID];
  console.log(session);
  let player1 = session.PLAYERS.Player1;
  let player2 = session.PLAYERS.Player2;
  let p1score = 0;
  let p2score = 0;
  let gamesCount = Object.keys(session.Games)
  for (const gameId of gamesCount) {
    const game = session.Games[gameId];
    // Perform actions with each game object
    if(game.winner===player1){
      p1score++
    }else{
      p2score++
    }
  }

  reply.send({ player1Score: p1score, player2Score: p2score });

})});

fastify.post('/new', (request, reply) => {
  console.log(request.body);
  reply.send({ message: 'Success' });
});

fastify.post('/delete', (request, reply) => {
  console.log(request.body);
  reply.send({ message: 'Success' });
});

fastify.post('/open', (request, reply) => {
  console.log(request.body);
  reply.send({ message: 'Success' });

});

fastify.post('/history', (request, reply) => {
  console.log(request.body);

  reply.send({ message: 'Success' });
});

fastify.listen({port, host: "0.0.0.0"}, (err, address) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  console.log(`Server listening on ${address}`);
});
