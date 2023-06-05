const fs = require('fs');
const fastify = require('fastify')();
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

fastify.post('/win', (request, reply) => {
  console.log(request.body);
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
