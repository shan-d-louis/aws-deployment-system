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
const PORT = process.env.PORT || 9090
app.listen(PORT, () => {
    console.log(`App running on port ${PORT}`)
})