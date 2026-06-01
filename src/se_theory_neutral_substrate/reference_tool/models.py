"""reference_tool/models.py - Reference-tool data models."""

from dataclasses import dataclass, field
from pathlib import Path

__all__ = [
    "ArtifactPlan",
    "ArtifactResult",
]


@dataclass(frozen=True)
class ArtifactPlan:
    """Validated execution plan for one reference artifact."""

    artifact_id: str
    path: Path
    kind: str
    section: str


@dataclass
class ArtifactResult:
    """Validation or scaffold result for one reference artifact."""

    artifact_id: str
    ok: bool = True
    messages: list[str] = field(default_factory=list)
    wrote: bool = False
    added: int = 0
    orphaned: int = 0

    def emit(self, prefix: str, message: str) -> None:
        """Append a formatted status message."""
        self.messages.append(f"  {prefix}  {message}")

    def fail(self, message: str) -> None:
        """Record a failure message and mark the artifact invalid."""
        self.ok = False
        self.emit("FAIL", message)

    def warn(self, message: str) -> None:
        """Record a warning message."""
        self.emit("warn", message)

    def added_sym(self, message: str) -> None:
        """Record a newly added symbol message."""
        self.emit("+   ", message)

    def note(self, message: str) -> None:
        """Record an informational message."""
        self.emit("    ", message)
