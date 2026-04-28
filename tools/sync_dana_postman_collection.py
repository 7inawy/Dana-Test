#!/usr/bin/env python3
"""Repair Dana.postman_collection.json: empty request URLs, metadata, Paymob method."""

from __future__ import annotations

import copy
import json
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLLECTION = ROOT / "Dana.postman_collection.json"

DESCRIPTION = """# Dana API (mobile)

Canonical route constants live in the Flutter repo: `lib/core/api/api_endpoint.dart`.

All paths below `{{local}}` / `{{dana}}` are under the API base that **includes** `/api` and then `/v1/...` (e.g. `http://localhost:3000/api/` + `v1/parentMe`).

### Auth (public — no Bearer)
- POST `/v1/parent/pre-SignUp` (multipart `data` + optional `file`)
- POST `/v1/parent/verify-signUp`
- POST `/v1/parent/pre-signIn`
- POST `/v1/parent/verify-signIn`
- POST `/v1/parent/reset-password`
- POST `/v1/parent/verify-password-otp`

### Auth (Bearer)
- POST `/v1/parent/change-password`

### Google OAuth (as implemented in app)
- GET `/v1/parent/google`
- GET `/v1/parent/google/callback` (server redirect; query params from IdP)
- GET `/v1/parent/google/compelete` (backend spelling)

### Parent profile
- GET/PATCH/DELETE `/v1/parentMe`
- POST `/v1/parentMe/addChild` (JSON)
- PATCH `/v1/parentMe/updateChild/:childId` (multipart `data` + optional `file`)

### Doctors & bookings
- CRUD `/v1/doctor`, `/v1/doctor/:id`
- POST/GET `/v1/booking`; GET/DELETE `/v1/booking/:id`; PATCH `/v1/booking/:id`
- GET `/v1/booking/myAppointment/:parentId`
- POST `/v1/booking/:bookingId/rate` (JSON `rating`)
- DELETE `/v1/booking/cancel/child/:childId` (Flutter `BookingService.cancelByChildId`)
- GET `/v1/booking/todayDoctorAppointment/:doctorId` (doctor dashboard; web-first)

### Content
- GET `/v1/videos`, `/v1/videos/:id`, `/v1/videos/search?q=`
- GET `/v1/textBooks`, `/v1/textBooks/:id`, `/v1/textBooks/search?q=`

### Child: growth, skills, vaccinations, sensory
- GET/POST `/v1/child/:childId/growth`; GET `/v1/child/:childId/growth/latest`
- GET `/v1/skills`; GET `/v1/skills/:skillId/child/:childId/checklist`; POST `/v1/skills/toggle/child/:childId`
- GET `/v1/child/:childId/childVaccinations`; POST `/v1/child/:childId/childVaccinations/generate`
- PATCH `/v1/child/:childId/childVaccinations/:vaccinationId/take`
- GET `/v1/vaccinations`
- GET `/v1/sensory-test/`; POST `/v1/sensory-test/:childId`

### Paymob
- GET `/v1/paymob/callback` (provider redirect; matches `ApiEndpoint.paymobCallback`)
"""


def fix_item_requests(items: list) -> int:
    """Fill empty request.url from first saved example originalRequest. Returns count fixed."""
    fixed = 0

    for item in items:
        if "item" in item:
            fixed += fix_item_requests(item["item"])
            continue

        req = item.get("request")
        if not req or not isinstance(req, dict):
            continue

        url = req.get("url")
        if not isinstance(url, dict) or (url.get("raw") or "").strip() != "":
            continue

        name = item.get("name", "")

        for resp in item.get("response") or []:
            orq = resp.get("originalRequest")
            if not orq:
                continue
            ourl = orq.get("url")
            if isinstance(ourl, dict) and (ourl.get("raw") or "").strip():
                req["url"] = copy.deepcopy(ourl)
                if orq.get("method"):
                    req["method"] = orq["method"]
                fixed += 1
                break

        # Still empty: known defaults
        url = req.get("url", {})
        if (url.get("raw") or "").strip() != "":
            continue

        if name == "google-callback":
            req["url"] = {
                "raw": "{{local}}v1/parent/google/callback",
                "host": ["{{local}}v1"],
                "path": ["parent", "google", "callback"],
            }
            req["description"] = (
                "OAuth redirect target. In real flows the browser lands here with "
                "query parameters from Google; use values from the `/v1/parent/google` step."
            )
            fixed += 1
        elif name == "get-today-doctor-appointment":
            # See docs/WIRING_STATUS.md — aligns with existing `doctorAppointment` examples.
            req["url"] = {
                "raw": "{{local}}v1/booking/todayDoctorAppointment/69316d56b6ea9f66f803e64a",
                "host": ["{{local}}v1"],
                "path": [
                    "booking",
                    "todayDoctorAppointment",
                    "69316d56b6ea9f66f803e64a",
                ],
            }
            req.setdefault(
                "description",
                "Doctor dashboard: today's appointments. Replace doctor id as needed.",
            )
            fixed += 1

    return fixed


def walk(items: list):
    for item in items:
        yield item
        if "item" in item:
            yield from walk(item["item"])


def apply_paymob_get(items: list) -> int:
    changed = 0
    for item in walk(items):
        req = item.get("request")
        if not req:
            continue
        url = req.get("url", {})
        raw = (url.get("raw") or "") if isinstance(url, dict) else ""
        if "paymob/callback" in raw and req.get("method") == "POST":
            req["method"] = "GET"
            req.pop("body", None)
            changed += 1
    return changed


def prune_empty_stub_requests(items: list) -> int:
    """Remove placeholder requests (empty URL, no nested folder, no saved examples)."""
    removed = 0
    i = 0
    while i < len(items):
        it = items[i]
        if "item" in it:
            removed += prune_empty_stub_requests(it["item"])
            i += 1
            continue
        name = it.get("name") or ""
        req = it.get("request") or {}
        url = req.get("url") or {}
        raw = (url.get("raw") or "").strip()
        is_stub = (
            not it.get("item")
            and raw == ""
            and not (it.get("response") or [])
            and name in ("New Request", "upload-file")
        )
        if is_stub:
            items.pop(i)
            removed += 1
            continue
        i += 1
    return removed


def main() -> None:
    data = json.loads(COLLECTION.read_text(encoding="utf-8"))

    n_fix = fix_item_requests(data["item"])
    n_pay = apply_paymob_get(data["item"])
    n_rm = prune_empty_stub_requests(data["item"])

    info = data.setdefault("info", {})
    info["description"] = DESCRIPTION
    info["updatedAt"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.000Z")

    # getMe: ensure Bearer like other authenticated parentMe calls
    for item in walk(data["item"]):
        if item.get("name") == "getMe" and "request" in item:
            r = item["request"]
            if not r.get("auth"):
                r["auth"] = {
                    "type": "bearer",
                    "bearer": [
                        {"key": "token", "value": "{{jwt}}", "type": "string"},
                    ],
                }
            r.setdefault("description", "GET current parent profile (requires JWT).")

    COLLECTION.write_text(
        json.dumps(data, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    print(
        f"Wrote {COLLECTION.name}: "
        f"urls_fixed={n_fix}, paymob_method_fixed={n_pay}, root_stubs_removed={n_rm}"
    )


if __name__ == "__main__":
    main()
