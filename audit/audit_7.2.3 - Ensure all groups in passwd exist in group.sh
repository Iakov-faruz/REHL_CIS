#!/usr/bin/env bash
# CIS 7.2.3 - Ensure all groups in passwd exist in group file
PASS=0; FAIL=0
echo "=== CIS 7.2.3 - Groups Consistency ==="
{
 a_passwd_group_gid=("$(awk -F: '{print $4}' /etc/passwd | sort -u)")
 a_group_gid=("$(awk -F: '{print $3}' /etc/group | sort -u)")
 a_passwd_group_diff=("$(printf '%s\n' "${a_group_gid[@]}" "${a_passwd_group_gid[@]}" | sort | uniq -u)")
 found=0
 while IFS= read -r l_gid; do
  result=$(awk -F: '($4 == '"$l_gid"') {print " - User: \"" $1 "\" has GID: \"" $4 "\" which does not exist in /etc/group" }' /etc/passwd)
  [ -n "$result" ] && { echo "[FAIL] $result"; found=1; }
 done < <(printf '%s\n' "${a_passwd_group_gid[@]}" "${a_passwd_group_diff[@]}" | sort | uniq -D | uniq)
 if [ "$found" -eq 0 ]; then echo "[PASS] All groups in passwd exist in group"; ((PASS++)); else ((FAIL++)); fi
}
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
