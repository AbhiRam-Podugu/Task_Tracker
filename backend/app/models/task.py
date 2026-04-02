from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.orm import relationship
from app.database.db import Base


class Task(Base):
    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True, index=True)

    title = Column(String, nullable=False)
    description = Column(String, nullable=False)
    due_date = Column(Date, nullable=False)
    status = Column(String, nullable=False)

    blocked_by = Column(Integer, ForeignKey("tasks.id"), nullable=True)

    # self-referencing relationship
    blocked_task = relationship("Task", remote_side=[id])