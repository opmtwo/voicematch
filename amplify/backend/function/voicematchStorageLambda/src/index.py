
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum

# from routers import me, avatars, members, fields, workspaces, queues, docs

app = FastAPI()

origins = [
    "http://localhost",
    "*",  # remove this in production
]

methods = ["*"]

headers = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=methods,
    allow_headers=headers,
)


# app.include_router(me.router)
# app.include_router(avatars.router)
# app.include_router(members.router)
# app.include_router(workspaces.router)
# app.include_router(queues.router)
# app.include_router(fields.router)
# app.include_router(docs.router)


@app.get("/api/v1/hello")
def get_root():
    return {"message": "Hello World"}


handler = Mangum(app, lifespan="off")
