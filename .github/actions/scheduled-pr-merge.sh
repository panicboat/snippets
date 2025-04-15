#!/bin/bash
set -eux -o pipefail

: "$COMMENT"

# Check command type
if [[ "$COMMENT" == "/schedule-merge-jst"* ]]; then
  # For JST (Asia/Tokyo) timezone specification
  JST_TIME=$(echo "$COMMENT" | grep -oP '/schedule-merge-jst \K[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}')
  if [ -z "$JST_TIME" ]; then
    echo "Format is incorrect. Please specify in the format /schedule-merge-jst YYYY-MM-DDThh:mm:ss."
    exit 1
  fi

  # Convert JST to UTC
  MERGE_TIME_UTC=$(TZ=UTC date -d "TZ=\"Asia/Tokyo\" $JST_TIME" "+%Y-%m-%dT%H:%M:%SZ")
  TIMEZONE="JST (Asia/Tokyo)"
  ORIGINAL_TIME="$JST_TIME JST"
else
  # For UTC timezone specification
  MERGE_TIME_UTC=$(echo "$COMMENT" | grep -oP '/schedule-merge \K[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z')
  if [ -z "$MERGE_TIME_UTC" ]; then
    echo "Format is incorrect. Please specify in the format /schedule-merge YYYY-MM-DDThh:mm:ssZ."
    exit 1
  fi
  TIMEZONE="UTC (Coordinated Universal Time)"
  ORIGINAL_TIME="$MERGE_TIME_UTC"
fi

{
  echo "merge_time_utc=$MERGE_TIME_UTC"
  echo "timezone=$TIMEZONE"
  echo "original_time=$ORIGINAL_TIME"
} >> "$GITHUB_OUTPUT"
