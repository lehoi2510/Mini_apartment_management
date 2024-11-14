require('dotenv').config()
const express = require('express')
const { connectDB } = require('./config/databaseConfig')
const Router = require('./routes/indexRoute')
const app = express()

const PORT = process.env.PORT || 3000

Router(app)
connectDB()

app.listen(PORT, () => { console.log(`App is running on http://localhost:${PORT}`) })

