import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Dashboard from './components/Dashboard';
import CreateLink from './components/CreateLink';
import './App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <header className="app-header">
          <h1>Link Tracking System - DOOH Analytics</h1>
          <nav>
            <a href="/">Dashboard</a>
            <a href="/create">Criar Link</a>
          </nav>
        </header>
        <main className="app-main">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/create" element={<CreateLink />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;
