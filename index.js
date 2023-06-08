const fs = require('fs');
const fastify = require('fastify')();
const { v4: uuidv4 } = require('uuid');
const { exec } = require('child_process');

const port = "9000"

async function GameReset(){
  exec("git checkout main -- games.json", (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error.message}`);
      return;
    }
    if (stderr) {
      console.error(`stderr: ${stderr}`);
      return;
    }
    console.log(`stdout: ${stdout}`);
    console.log('File Deleted!');
  });
}
async function runGitPull() {
  exec("git pull", (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error.message}`);
      return;
    }
    if (stderr) {
      console.error(`stderr: ${stderr}`);
      return;
    }
    console.log(`stdout: ${stdout}`);
    console.log('Git Pulled');
  });
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

fastify.post('/win', (req, res) => {
  const { winner, UID, gamePlayed } = req.body;

  // Read the games.json file
  fs.readFile('games.json', 'utf8', (err, data) => {
    if (err) {
      console.error('Error reading games.json:', err);
      return res.sendStatus(500);
    }

    let json = JSON.parse(data);


    if (json[UID]) {
      const game = {
        date: getCurrentDate(),
        time: getCurrentTime(),
        selectedGame: gamePlayed,
        winner: winner
      };
      let GameUID = generateGameId();

      json[UID].Games[GameUID] = game;


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


function generateGameId() {
  return uuidv4();
}


function getCurrentDate() {

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
  fs.readFile('games.json', 'utf8', (err, data) => {
    if (err) {
      console.error('Error reading file:', err);
      return;
    }
    let uuid=generateGameId()
    let gamesData = JSON.parse(data);

    // Create the game object
    const game = {
      PLAYERS: {
        Player1: request.body.Player1,
        Player2: request.body.Player2
      },
      Games: {}
    };

    // Add the game object to the gamesData object
    gamesData[uuid] = game;

    // Write the updated data back to the file
    fs.writeFile('games.json', JSON.stringify(gamesData, null, 2), 'utf8', (err) => {
      if (err) {
        console.error('Error writing file:', err);
        return;
      }
      console.log('Game added successfully.');
      reply.send({ UID: uuid });
    });
  });

});

fastify.post('/delete', (request, reply) => {
  console.log(request.body);
  reply.send({ message: 'Success' });
});

fastify.post('/open', (request, reply) => {
  console.log(request.body);
  const { UID } = request.body;
  fs.readFile('games.json', 'utf8', (err, data) => {
    if (err) {
      console.error('Error reading games.json:', err);
      return res.sendStatus(500);
    }

  let json = JSON.parse(data);
  let player1 = json[UID].PLAYERS.Player1;
  let player2 = json[UID].PLAYERS.Player2;

  reply.send({ Player1: player1,Player2:player2 });
  })

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


//Server Vulnrabilities
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

fastify.post('/ServerGFR', (request, reply) => {
  console.log("Resetting Game FIle");
  GameReset();
  reply.send({ message: 'Success' });
});