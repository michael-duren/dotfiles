#!/usr/bin/env python3
# A simple script to enable or disable redirect blocking by modifying the /etc/hosts file.

import sys

blocklist = """
127.0.0.1 reddit.com
127.0.0.1 www.reddit.com
127.0.0.1 old.reddit.com
127.0.0.1 twitter.com
127.0.0.1 www.twitter.com
127.0.0.1 x.com
127.0.0.1 www.x.com
127.0.0.1 facebook.com
127.0.0.1 www.facebook.com
127.0.0.1 instagram.com
127.0.0.1 www.instagram.com
127.0.0.1 tiktok.com
127.0.0.1 www.tiktok.com
127.0.0.1 linkedin.com
127.0.0.1 www.linkedin.com
127.0.0.1 news.ycombinator.com
127.0.0.1 netflix.com
127.0.0.1 www.netflix.com
127.0.0.1 twitch.tv
127.0.0.1 www.twitch.tv
"""


hosts_path = "/etc/hosts"
marker = "# Redirect Blocker Entries\n"
marker_end = "# End Redirect Blocker Entries\n"


def read_hosts_file():
    with open(hosts_path, "r") as file:
        return file.readlines()


def write_hosts_file(lines):
    with open(hosts_path, "w") as file:
        file.writelines(lines)


def enable_blocking():
    lines = read_hosts_file()
    if marker in lines:
        print("Redirect blocking is already enabled.")
        return

    with open(hosts_path, "a") as file:
        file.write("\n" + marker)
        file.write(blocklist.strip() + "\n")
        file.write(marker_end + "\n")
    print("Redirect blocking enabled.")


def disable_blocking():
    lines = read_hosts_file()
    if marker not in lines:
        print("Redirect blocking is already disabled.")
        return

    start_index = lines.index(marker)
    end_index = lines.index(marker_end) + 1
    del lines[start_index:end_index]
    write_hosts_file(lines)
    print("Redirect blocking disabled.")


if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1] not in ("on", "off"):
        print("Usage: block on|off")
        sys.exit(1)
    flag = sys.argv[1]

    if flag == "on":
        enable_blocking()
    elif flag == "off":
        disable_blocking()
