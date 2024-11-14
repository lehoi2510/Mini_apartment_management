const express = require('express')
const userController = require('../controllers/userController')
const Router = express.Router()

Router.get('/All', userController.getAllUsers)


module.exports = Router