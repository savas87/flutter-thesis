const express = require('express');
const routes = require('./routes');
const connectToDatabase = require('./db');

const app = express();
const port = process.env.PORT || 3000

app.use(express.json());
app.use('/api', routes);

app.use((err, req, res, next) => {
    console.log(err.stack);
    res.status(err.statusCode || 500).send({error: err.message});
})

async function startServer(){
    await connectToDatabase();
    
    app.listen(port, () => {
        console.log('Server listening at Port: '+port);
    })
}

module.exports = startServer;