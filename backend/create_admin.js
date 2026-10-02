// Crée le premier compte administrateur.
// Usage : node create_admin.js "Nom" admin@exemple.com motdepasse
require('dotenv').config();
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const User = require('./models/User');

async function main() {
  const [name, email, password] = process.argv.slice(2);
  if (!name || !email || !password || password.length < 6) {
    console.error('Usage : node create_admin.js "Nom" email motdepasse (6 caractères minimum)');
    process.exit(1);
  }

  await mongoose.connect(process.env.MONGODB_URI);
  if (await User.findOne({ email })) {
    console.error('Un utilisateur avec cet email existe déjà.');
  } else {
    const hashedPassword = await bcrypt.hash(password, 10);
    await User.create({ name, email, password: hashedPassword, role: 'admin' });
    console.log(`Administrateur ${email} créé.`);
  }
  await mongoose.disconnect();
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
