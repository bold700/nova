#!/usr/bin/env python3
"""
Nova Kanban Server
==================
Een simpele Kanban-bord server voor je bot en persoonlijke taken.

Gebruik:
    python3 server.py

API Endpoints:
    GET  /api/tasks          - Haal alle taken op
    POST /api/tasks          - Maak nieuwe taak
    PUT  /api/tasks/<id>     - Update taak (status, titel, etc.)
    DELETE /api/tasks/<id>   - Verwijder taak

Taak structuur:
    {
        "id": "uuid",
        "title": "Taak titel",
        "description": "Optionele beschrijving",
        "status": "todo" | "doing" | "done",
        "type": "bot" | "personal",
        "created": "ISO timestamp",
        "updated": "ISO timestamp"
    }
"""

import json
import os
import uuid
from datetime import datetime
from pathlib import Path
from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS

app = Flask(__name__, static_folder='static')
CORS(app)

# Data bestand naast server.py
DATA_FILE = Path(__file__).parent / 'tasks.json'

def load_tasks():
    """Laad taken uit JSON bestand."""
    if DATA_FILE.exists():
        with open(DATA_FILE, 'r', encoding='utf-8') as f:
            return json.load(f)
    return {"tasks": []}

def save_tasks(data):
    """Sla taken op naar JSON bestand."""
    with open(DATA_FILE, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

# =============================================================================
# API Routes
# =============================================================================

@app.route('/')
def index():
    """Serve de Kanban frontend."""
    return send_from_directory('.', 'index.html')

@app.route('/api/tasks', methods=['GET'])
def get_tasks():
    """Haal alle taken op."""
    data = load_tasks()
    return jsonify(data['tasks'])

@app.route('/api/tasks', methods=['POST'])
def create_task():
    """Maak een nieuwe taak aan."""
    body = request.json or {}

    task = {
        "id": str(uuid.uuid4())[:8],
        "title": body.get('title', 'Nieuwe taak'),
        "description": body.get('description', ''),
        "status": body.get('status', 'todo'),
        "type": body.get('type', 'personal'),  # 'bot' of 'personal'
        "created": datetime.now().isoformat(),
        "updated": datetime.now().isoformat()
    }

    data = load_tasks()
    data['tasks'].append(task)
    save_tasks(data)

    return jsonify(task), 201

@app.route('/api/tasks/<task_id>', methods=['PUT'])
def update_task(task_id):
    """Update een bestaande taak."""
    body = request.json or {}
    data = load_tasks()

    for task in data['tasks']:
        if task['id'] == task_id:
            # Update velden die meegegeven zijn
            if 'title' in body:
                task['title'] = body['title']
            if 'description' in body:
                task['description'] = body['description']
            if 'status' in body:
                task['status'] = body['status']
            if 'type' in body:
                task['type'] = body['type']
            task['updated'] = datetime.now().isoformat()

            save_tasks(data)
            return jsonify(task)

    return jsonify({"error": "Taak niet gevonden"}), 404

@app.route('/api/tasks/<task_id>', methods=['DELETE'])
def delete_task(task_id):
    """Verwijder een taak."""
    data = load_tasks()
    original_count = len(data['tasks'])
    data['tasks'] = [t for t in data['tasks'] if t['id'] != task_id]

    if len(data['tasks']) < original_count:
        save_tasks(data)
        return jsonify({"success": True})

    return jsonify({"error": "Taak niet gevonden"}), 404

@app.route('/api/tasks/<task_id>/move', methods=['POST'])
def move_task(task_id):
    """Verplaats taak naar andere kolom (shortcut voor status update)."""
    body = request.json or {}
    new_status = body.get('status')

    if new_status not in ['todo', 'doing', 'done']:
        return jsonify({"error": "Ongeldige status"}), 400

    data = load_tasks()
    for task in data['tasks']:
        if task['id'] == task_id:
            task['status'] = new_status
            task['updated'] = datetime.now().isoformat()
            save_tasks(data)
            return jsonify(task)

    return jsonify({"error": "Taak niet gevonden"}), 404

# =============================================================================
# Bot Helper Routes (makkelijk aan te roepen vanuit scripts/cron)
# =============================================================================

@app.route('/api/bot/add', methods=['POST'])
def bot_add_task():
    """
    Simpele route voor bot om taken toe te voegen.

    Voorbeeld curl:
        curl -X POST http://localhost:5555/api/bot/add \
             -H "Content-Type: application/json" \
             -d '{"title": "Support mail beantwoorden", "description": "Ticket #123"}'
    """
    body = request.json or {}

    task = {
        "id": str(uuid.uuid4())[:8],
        "title": body.get('title', 'Bot taak'),
        "description": body.get('description', ''),
        "status": body.get('status', 'todo'),
        "type": "bot",
        "created": datetime.now().isoformat(),
        "updated": datetime.now().isoformat()
    }

    data = load_tasks()
    data['tasks'].append(task)
    save_tasks(data)

    print(f"[BOT] Nieuwe taak toegevoegd: {task['title']}")
    return jsonify(task), 201

@app.route('/api/bot/complete/<task_id>', methods=['POST'])
def bot_complete_task(task_id):
    """
    Simpele route voor bot om taak als done te markeren.

    Voorbeeld curl:
        curl -X POST http://localhost:5555/api/bot/complete/abc123
    """
    data = load_tasks()
    for task in data['tasks']:
        if task['id'] == task_id:
            task['status'] = 'done'
            task['updated'] = datetime.now().isoformat()
            save_tasks(data)
            print(f"[BOT] Taak voltooid: {task['title']}")
            return jsonify(task)

    return jsonify({"error": "Taak niet gevonden"}), 404

# =============================================================================
# Main
# =============================================================================

if __name__ == '__main__':
    # Maak initieel tasks bestand als het niet bestaat
    if not DATA_FILE.exists():
        save_tasks({
            "tasks": [
                {
                    "id": "demo1",
                    "title": "Welkom bij Nova Kanban!",
                    "description": "Sleep taken tussen kolommen of klik om te bewerken.",
                    "status": "todo",
                    "type": "personal",
                    "created": datetime.now().isoformat(),
                    "updated": datetime.now().isoformat()
                },
                {
                    "id": "demo2",
                    "title": "Bot taak voorbeeld",
                    "description": "Taken van de bot worden automatisch toegevoegd.",
                    "status": "doing",
                    "type": "bot",
                    "created": datetime.now().isoformat(),
                    "updated": datetime.now().isoformat()
                }
            ]
        })
        print("Initieel tasks.json aangemaakt met demo taken.")

    print("""
╔═══════════════════════════════════════════════════════════╗
║             🎯 Nova Kanban Server                         ║
╠═══════════════════════════════════════════════════════════╣
║  Open in browser: http://localhost:5555                   ║
║  Mobiel (zelfde netwerk): http://<mac-ip>:5555           ║
╚═══════════════════════════════════════════════════════════╝
    """)

    # Host op 0.0.0.0 zodat het bereikbaar is vanaf andere devices
    # Render gebruikt PORT environment variable
    port = int(os.environ.get('PORT', 5555))
    app.run(host='0.0.0.0', port=port, debug=False)
