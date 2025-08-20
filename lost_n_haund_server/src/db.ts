import { MongoClient } from 'mongodb';
import "dotenv/config"

const uri = `mongodb+srv://${process.env.MONGO_USER}:${process.env.MONGO_PASS}@lostnhaund.o9effwu.mongodb.net/?retryWrites=true&w=majority&appName=LostnHAUnd`

const client = new MongoClient(uri);
const db = client.db('lost_n_haund')

export async function run() {
  try {
    const db = client.db('sample_mflix')
    const movies = db.collection('movies')

    const query = { title: 'Back to the Future' }
    const movie = await movies.findOne(query)

    console.log(movie)
    return movie

  } catch (e) {
    console.error("Error", e)
  }
}

export default db
