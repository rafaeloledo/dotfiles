//! Application errors with user-facing messages.

use std::fmt;
use std::path::Path;

pub type Result<T> = std::result::Result<T, AppError>;

#[derive(Debug)]
pub enum AppError {
    Message(String),
    IoAt {
        path: String,
        source: std::io::Error,
    },
    Other(anyhow::Error),
}

impl fmt::Display for AppError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Message(msg) => write!(f, "{msg}"),
            Self::IoAt { path, source } => write!(f, "{path}: {source}"),
            Self::Other(err) => write!(f, "{err:#}"),
        }
    }
}

impl std::error::Error for AppError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            Self::IoAt { source, .. } => Some(source),
            Self::Other(err) => Some(err.as_ref()),
            Self::Message(_) => None,
        }
    }
}

impl From<anyhow::Error> for AppError {
    fn from(value: anyhow::Error) -> Self {
        Self::Other(value)
    }
}

impl AppError {
    pub fn message(msg: impl Into<String>) -> Self {
        Self::Message(msg.into())
    }

    pub fn io_at(path: impl AsRef<Path>, source: std::io::Error) -> Self {
        Self::IoAt {
            path: path.as_ref().display().to_string(),
            source,
        }
    }
}
