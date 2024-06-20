import sys
import re
import subprocess
import typing
import json
import os
from pathlib import Path

args = sys.argv[1:]

URLConfig = typing.TypedDict(
    "URLConfig",
    {
        "pattern": str,
        "browser": str,
        "args": typing.List[str]
    }
)

Config = typing.TypedDict(
    "Config",
    {
        "urls": typing.List[URLConfig],
        "defaultBrowser": str,
        "defaultArgs": typing.List[str],
        "args": typing.List[str]
    }
)

data_path = os.path.join(os.getenv('APPDATA'), 'Open-With')
config_path = os.path.join(data_path, 'config.json')

should_exit = False

if not os.path.exists(config_path) or "--init" in args:
    if not os.path.exists(data_path):
        os.mkdir(data_path)

    config = {
        "$schema": "https://raw.githubusercontent.com/cassiomaciell/OpenWith/main/config-shema.json",
        "urls": [
            URLConfig(
                pattern=r"(https?://)?(www\.)?(youtube\.com|youtu\.be|yt\.be)(/[^\s]*)?",
                browser="C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
                args=["--incognito"]
            ),
            URLConfig(
                pattern=r"https?://(www\.)?twitch\.tv/?",
                browser=f"{Path.home()}\\AppData\\Local\\Google\\Chrome SxS\\Application\\chrome.exe",
                args=[]
            )
        ],
        "defaultBrowser": "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
        "defaultArgs": [],
        "args": ["--single-argument"]
    }

    with open(config_path, "w") as out:
        json.dump(config, out, indent=2)
        out.write("\n")
    should_exit = True

if "--show-config" in args:
    os.startfile(config_path)
    should_exit = True

if should_exit:
    sys.exit(0)

url = args[0]

if not url:
    print("No URL provided")
    sys.exit(1)

with open(config_path) as f:
    config: Config = json.load(f)

for urlConfig in config["urls"]:
    if re.match(urlConfig["pattern"], url, re.IGNORECASE):
        subprocess.Popen(
            [urlConfig["browser"], *urlConfig["args"], *config["args"], url])
        sys.exit(0)

subprocess.Popen([config["defaultBrowser"], *
                 config["defaultArgs"], *config["args"], url])
sys.exit(0)
