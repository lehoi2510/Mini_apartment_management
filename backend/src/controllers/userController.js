const userService = require('../services/userService')

const getAllUsers = async (req, res) => {
    try {
        res.json({ message: 'Get all users successfully' })
        // const { data, message } = await userService.getAllUsers()
        // res.status(200).json({ data, message })
    } catch (error) {
        res.status(500).json({ message: error.message })
    }
}

module.exports = {
    getAllUsers,
}