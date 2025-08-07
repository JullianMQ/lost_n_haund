import { MongoClient, ServerApiVersion } from 'mongodb';
import "dotenv/config"

const uri = `mongodb+srv://${process.env.MONGO_USER}:${process.env.MONGO_PASS}@lostnhaund.o9effwu.mongodb.net/?retryWrites=true&w=majority&appName=LostnHAUnd`

// Create a MongoClient with a MongoClientOptions object to set the Stable API version
export const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

export async function run() {
  try {
    const db = client.db('sample_mflix')
    const movies = db.collection('movies')

    const query = { title: 'Back to the Future' }
    const movie = await movies.findOne(query)

    console.log(movie)
  } finally {
    // Ensures that the client will close when you finish/error
    await client.close();
  }
}
run().catch(console.dir);
