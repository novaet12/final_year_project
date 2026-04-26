import httpx
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter()

OPENROUTER_API_KEY = "your_openrouter_key_here"
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"

class ChatRequest(BaseModel):
    message: str


@router.post("/chat")
async def chat_with_ai(request: ChatRequest):
    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json",
    }

    payload = {
        "model": "mistralai/mistral-7b-instruct",
        "messages": [
            {"role": "system", "content": "You are a supportive, anonymous therapy assistant. Be empathetic and concise."},
            {"role": "user", "content": request.message}
        ]
    }

    async with httpx.AsyncClient() as client:
        response = await client.post(OPENROUTER_URL, headers=headers, json=payload)

    if response.status_code != 200:
        raise HTTPException(status_code=500, detail="AI Service unavailable")

    data = response.json()
    return {"reply": data['choices'][0]['message']['content']}