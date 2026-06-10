# RideIndia Backend + API Integration TODO

## [x] 1. Create backend project structure
   - rideindia-backend/package.json
   - rideindia-backend/server.js (Express setup)
   - rideindia-backend/db.js (SQLite setup + schema)

## [ ] 2. Backend dependencies
   - npm install express sqlite3 bcryptjs jsonwebtoken cors dotenv helmet express-rate-limit

## [ ] 3. Backend routes
   - /api/auth/register (POST)
   - /api/auth/login (POST)
   - /api/users/:id (GET)
   - /api/vehicles (GET)
   - /api/bookings (GET/POST for current user)
   - /api/bookings/:id (PATCH for cancel/status)

## [ ] 4. Update frontend HTML
   - Replace localStorage with API calls
   - Add JWT token handling
   - Add loading/error states

## [ ] 5. Test full flow
   - Backend: npm start
   - Frontend: open HTML
   - Signup/Login -> Book vehicle -> Dashboard

## [ ] 6. Final demo command
