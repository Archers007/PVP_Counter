const fs = require('fs');
const fastify = require('fastify')();
const simpleGit = require('simple-git');
const port = "9000"


const gameHistoryFilePath = 'gameHistory.json';
let gameHistory = [];

// Check if the game history JSON file exists
if (fs.existsSync(gameHistoryFilePath)) {
  // Read the game history JSON file and parse it into the gameHistory array
  const gameHistoryData = fs.readFileSync(gameHistoryFilePath, 'utf8');
  gameHistory = JSON.parse(gameHistoryData);
  console.log(gameHistory);
}
async function runGitPull() {
  const git = simpleGit();

  try {
    await git.pull();
    console.log('Git pull completed successfully.');
  } catch (error) {
    console.error('Error during git pull:', error);
  }
}

// fastify.post('/win', (request, reply) => {
//   console.log(request.body);

//   reply.send({ message: 'Success' });
// });

fastify.post('/win', (req, res) => {
  const { winner, UID } = req.body;

  // Read the games.json file
  fs.readFile('games.json', 'utf8', (err, data) => {
    if (err) {
      console.error('Error reading games.json:', err);
      return res.sendStatus(500);
    }

    let games = JSON.parse(data);

    // Find the game with the matching UID
    if (games[UID]) {
      const game = {
        date: getCurrentDate(),
        time: getCurrentTime(),
        selectedGame: 'Chess', // Example value, modify as needed
        winner: winner
      };

      // Add the new game to the Games object
      games[UID].Games[generateGameId()] = game;

      // Update the games.json file
      fs.writeFile('games.json', JSON.stringify(games, null, 2), 'utf8', (err) => {
        if (err) {
          console.error('Error writing to games.json:', err);
          return res.sendStatus(500);
        }

        res.send({games});
      });
    } else {
      console.error('Game not found for UID:', UID);
      res.sendStatus(404);
    }
  });
});

// Utility functions to generate a game ID and get the current date/time
function generateGameId() {
  // Generate a unique ID using a suitable algorithm
  return 'ABC123XYZ'; // Example value, modify as needed
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

fastify.post('/score', (request, reply) => {
  console.log(request.body);
  reply.send({ message: 'Success' });
});

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
