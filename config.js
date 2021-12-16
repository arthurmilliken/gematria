require('dotenv').config()

export const DB_PATH = process.env.DB_PATH || '/mnt/d/data/gematria.db';
export const SOURCE = process.env.SOURCE || '/mnt/d/data/scripture/bibles.txt';
