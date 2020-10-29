const express = require("express");
const app = express()
var cors = require('cors');
app.use(cors({
    origin: ["http://localhost:8200", "http://127.0.0.1:8200"],
    credentials: true,
}));
const port = 5000

app.use(express.json({ extended: false }));

app.get('/', function (req, res) {
        res.send('Hello World!');
    });

app.post("/enrol", async (req, res) => {
    const { email } = req.body;
    console.log(email);
    // return res.send("Enrollment api route!!!")

});




app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
});


