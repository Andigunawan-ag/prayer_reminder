const express = require('express');
const path = require('path');
const cors = require('cors');  // Tambahkan ini

const app = express();
const PORT = 3000;

app.use(cors());  // Tambahkan ini untuk mengizinkan semua permintaan CORS

// Middleware untuk menyajikan file statis dari folder assets
app.use('/audio', express.static(path.join(__dirname, 'assets')));

// Endpoint untuk mendapatkan URL audio adzan
app.get('/api/adhan', (req, res) => {
  const adhanType = req.query.type || 'makkah'; // Default ke Makkah jika tidak ada query
  const adhanMap = {
    makkah: 'adhan_makkah.mp3',
    madinah: 'adhan_madinah.mp3',
    alaqsa: 'adhan_alaqsa.mp3',
  };

  const adhanFile = adhanMap[adhanType.toLowerCase()];
  if (adhanFile) {
    res.json({ adhan_url: `http://localhost:${PORT}/audio/${adhanFile}` });
  } else {
    res.status(404).json({ error: 'Adhan type not found' });
  }
});

// Jalankan server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});