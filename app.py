from flask import Flask
from datetime import datetime
import pytz

app = Flask(__name__)

@app.route("/")
def home():
    tbilisi_time = datetime.now(pytz.timezone('Asia/Tbilisi')).strftime('%Y-%m-%d %H:%M:%S')
    message = "Dear Guest, welcome on this simple web page showing the time: "
    return f"{message}{tbilisi_time}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
