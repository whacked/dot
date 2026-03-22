_display_name=$(xrandr | grep ' connected' | grep -v eDP | awk '{print $1}')
for workspace in $(i3-msg -t get_workspaces | jq '.[] | .num' | awk '$0%2==0'); do
    i3-msg "[workspace=$workspace]" move workspace to output $_display_name
done
