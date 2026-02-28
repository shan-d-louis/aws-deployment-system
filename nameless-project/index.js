const express = require('express')
const app = express()

// For load balancer
app.get('/health', (req, res) => {
    res.json({status: 'healthy'})
})

//Homepage
app.get('/', (req, res) => {
    res.json({
        message : "working",
        environment : process.env.ENVIRONMENT || 'unknown'
    })
})

//PORT
const PORT = process.env.PORT || 3000
app.listen(PORT, '0.0.0.0', () => {
    console.log(`App running on port: ${PORT}`)
})