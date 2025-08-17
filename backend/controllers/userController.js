const User = require('../models/User');

// Register user
exports.registerUser = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    // Validate required fields
    if (!name || !email || !password) {
      return res.status(400).json({ message: "All fields are required" });
    }

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists" });
    }

    // Create new user
    const newUser = new User({ name, email, password });
    await newUser.save();

    res.status(201).json({ 
      message: "User created successfully", 
      user: { 
        id: newUser._id, 
        name: newUser.name, 
        email: newUser.email 
      } 
    });
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};



