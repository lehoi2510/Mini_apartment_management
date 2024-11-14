const userRoute = require('./userRoute')

const Router = (app) => {

    app.use('/user', userRoute)

    app.get('/', (req, res) => {
        res.send('Hello World!')
    })
}

module.exports = Router