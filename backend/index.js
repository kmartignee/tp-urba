import express from 'express';
import pkg from 'pg';
import cors from 'cors';

const { Pool } = pkg;

const app = express();
app.use(express.json());
app.use(cors());

const pool = new Pool({
    host: process.env.POSTGRES_HOST || 'localhost',
    database: process.env.POSTGRES_DB || 'recipes',
    user: process.env.POSTGRES_USER || 'recipe_user',
    password: process.env.POSTGRES_PASSWORD || 'recipe_super_secret_password',
    port: 5432
});

app.get('/recipes', async (req, res) => {
    const { rows } = await pool.query('SELECT id, name, preparation_time, difficulty, is_favorite FROM recipes ORDER BY id');
    res.json(rows);
});

app.post('/recipes', async (req, res) => {
    const { name, preparation_time, difficulty } = req.body;
    const { rows } = await pool.query(
        'INSERT INTO recipes (name, preparation_time, difficulty, is_favorite) VALUES ($1, $2, $3, $4) RETURNING *',
        [name, preparation_time, difficulty, false]
    );
    res.status(201).json(rows[0]);
});

app.put('/recipes/:id', async (req, res) => {
    const id = req.params.id;
    const { name, preparation_time, difficulty, is_favorite } = req.body;
    const { rows } = await pool.query(
        'UPDATE recipes SET name = $1, preparation_time = $2, difficulty = $3, is_favorite = $4 WHERE id = $5 RETURNING *',
        [name, preparation_time, difficulty, is_favorite, id]
    );
    res.json(rows[0]);
});

app.delete('/recipes/:id', async (req, res) => {
    const id = req.params.id;
    await pool.query('DELETE FROM recipes WHERE id = $1', [id]);
    res.status(204).send();
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`API Node.js démarrée sur le port ${port}`);
});