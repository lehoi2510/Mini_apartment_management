const { User } = require('../models/userModel')


const getAllUsers = async () => {
    try {
        const data = await User.findAll()
        return {
            data,
            message: 'Get all users successfully',
        }
    } catch (error) {
        throw new Error(error.message)
    }
}

module.exports = {
    getAllUsers,
}