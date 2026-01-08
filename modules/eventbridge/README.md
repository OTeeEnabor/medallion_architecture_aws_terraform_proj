
# EventBridge Orchestration (Stub)

Use Amazon EventBridge + AWS Lambda or Step Functions to trigger Glue jobs on a schedule or events.

This module is intentionally minimal to avoid invalid targets. Implement one of:
- EventBridge rule -> Lambda -> StartGlueJob API
- Step Functions state machine to run Bronze->Silver then Silver->Gold
