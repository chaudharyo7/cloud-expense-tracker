from flask import Flask
from flask_cors import CORS

from .db import init_db
from .routes import api


def create_app():
    app = Flask(__name__)
    CORS(app)

    init_db()
    app.register_blueprint(api, url_prefix="/api")

    return app


app = create_app()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
