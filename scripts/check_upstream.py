#!/usr/bin/env python3
"""
Check if a Fooocus fork has new commits since the last build.
Exit with 0 if rebuild is needed, 1 if not.
"""

import os
import sys
import requests
from pathlib import Path


def get_latest_commit(repo: str) -> str:
    """Get the latest commit SHA from a GitHub repository."""
    api_url = f"https://api.github.com/repos/{repo}/commits?per_page=1"
    
    try:
        response = requests.get(api_url, timeout=30)
        response.raise_for_status()
        commits = response.json()
        
        if commits and len(commits) > 0:
            return commits[0]['sha']
        else:
            raise ValueError(f"No commits found for {repo}")
            
    except requests.exceptions.RequestException as e:
        print(f"Error fetching commits for {repo}: {e}", file=sys.stderr)
        sys.exit(2)


def get_last_built_commit(fork_name: str) -> str:
    """Get the last built commit SHA from state file."""
    state_file = Path(f"build/state/{fork_name}.txt")
    
    if state_file.exists():
        return state_file.read_text().strip()
    
    return ""


def main():
    if len(sys.argv) != 3:
        print("Usage: check_upstream.py <fork_name> <repo>", file=sys.stderr)
        sys.exit(2)
    
    fork_name = sys.argv[1]
    repo = sys.argv[2]
    
    # Get latest commit from upstream
    latest_commit = get_latest_commit(repo)
    print(f"Latest commit for {repo}: {latest_commit}")
    
    # Get last built commit
    last_built = get_last_built_commit(fork_name)
    
    if last_built:
        print(f"Last built commit: {last_built}")
    else:
        print("No previous build found")
    
    # Compare commits
    if latest_commit != last_built:
        print("Build needed: commits differ")
        sys.exit(0)  # Exit 0 = build needed
    else:
        print("No build needed: commits are the same")
        sys.exit(1)  # Exit 1 = no build needed


if __name__ == "__main__":
    main()