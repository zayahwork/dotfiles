#!/usr/bin/env bash
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0 Safari/537.36"
ok(){ printf "  \033[32mOK  \033[0m %s\n" "$1"; }
no(){ printf "  \033[31mNO  \033[0m %s\n" "$1"; }

echo "OBS"
n=$(tasklist.exe /FI "IMAGENAME eq obs64.exe" 2>/dev/null | grep -c obs64.exe)
[ "$n" = "1" ] && ok "one obs64.exe running" || no "$n obs64.exe processes running (want 1)"
timeout 3 bash -c 'echo > /dev/tcp/127.0.0.1/4455' 2>/dev/null && ok "websocket listening on 4455" || no "websocket not listening on 4455"
python3 - <<'PY'
import json
try:
    d=json.load(open('/mnt/c/Users/Stuck/AppData/Roaming/obs-studio/plugin_config/obs-websocket/config.json'))
    good = d.get('server_enabled') and d.get('server_port')==4455 and d.get('auth_required') and len(d.get('server_password',''))>=16
    print(("  \033[32mOK  \033[0m " if good else "  \033[31mNO  \033[0m ")+f"config: enabled={d.get('server_enabled')} port={d.get('server_port')} auth={d.get('auth_required')} pw={len(d.get('server_password',''))} chars")
except Exception as e:
    print("  \033[31mNO  \033[0m config unreadable:", e)
PY

echo
echo "HANDLES"
c=$(/usr/bin/curl -sL --max-time 20 -A "$UA" -o /dev/null -w "%{http_code}" "https://kick.com/api/v2/channels/corpai"); [ "$c" = 200 ] && ok "kick.com/corpai   ($c)" || no "kick.com/corpai   ($c)"
r=$(/usr/bin/curl -sS --max-time 20 -H "Client-ID: kimne78kx3ncx6brgo4mv6wki5h1ko" -H "Content-Type: application/json" -d '{"query":"{user(login:\"zaysterfps\"){id}}"}' https://gql.twitch.tv/gql)
echo "$r" | grep -q '"id":"' && ok "twitch.tv/zaysterfps (GQL id present)" || no "twitch.tv/zaysterfps (no id)"
n=$(/usr/bin/curl -sL --max-time 25 -A "$UA" "https://www.youtube.com/@zaybuilds-b6o/streams" | grep -o '"videoId":"[A-Za-z0-9_-]\{11\}"' | sort -u | wc -l)
[ "$n" -ge 1 ] && ok "youtube @ZayBuilds-b6o ($n streams enumerated)" || no "youtube @ZayBuilds-b6o (0 streams)"
for h in CorppAI ZayahNelson0; do
  c=$(/usr/bin/curl -sL --max-time 20 -A "$UA" -o /dev/null -w "%{http_code}" "https://x.com/$h")
  printf "  \033[33mNA  \033[0m x.com/%s (%s) - x serves a JS shell to any slug, so this proves nothing\n" "$h" "$c"
done

echo
echo "SECRETS  (values never printed)"
python3 - <<'PY'
p='stream/secrets.env'
filled=[];empty=[]
for line in open(p,encoding='utf-8'):
    line=line.strip()
    if not line or line.startswith('#') or '=' not in line: continue
    k,v=line.split('=',1)
    (filled if v.strip() else empty).append(k)
for k in filled: print(f"  \033[32mOK  \033[0m {k}")
for k in empty:  print(f"  \033[31mNO  \033[0m {k}")
PY

echo
echo "REPO"
python3 - <<'PY'
import re,glob,os
def slug(h):
    s=h.strip().lower().replace('`','');s=re.sub(r'[^\w\s-]','',s,flags=re.UNICODE)
    return re.sub(r'\s+','-',s.strip())
bad=tot=0
for f in glob.glob('library/**/*.md',recursive=True):
    src=open(f,encoding='utf-8').read()
    a={slug(l[3:]) for l in src.split('\n') if l.startswith('## ')}|{slug(l[2:]) for l in src.split('\n') if l.startswith('# ')}
    for x in re.findall(r'\]\(#([^)]+)\)',src):
        tot+=1; bad+= x not in a
    for l in re.findall(r'\]\(([^)#][^)]*)\)',src):
        tot+=1; bad+= not os.path.exists(os.path.join(os.path.dirname(f),l))
print(("  \033[32mOK  \033[0m " if not bad else "  \033[31mNO  \033[0m ")+f"library links: {tot} checked, {bad} broken")
PY
apply --check 2>&1 | grep -q "nothing hidden" && ok "apply --check clean" || no "apply --check reports untracked files"
[ -z "$(git status --porcelain | grep -v '^??')" ] && ok "no uncommitted tracked changes" || no "uncommitted tracked changes present"
git fetch -q origin 2>/dev/null; [ "$(git rev-list --count origin/development..development)" = "0" ] && ok "development pushed" || no "development has unpushed commits"
