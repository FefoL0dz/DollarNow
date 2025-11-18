# Notification Planner Feature

## Overview
Create an "Alertar quando cair" module that allows users to schedule local notifications for currency thresholds after a specific datetime. This should live alongside existing modules without intrusive changes, but reuse core services (quotes, currency list) where sensible.

## Entry Point
- Expose from dashboard menu or a floating action button ("+ Alerta").
- Navigates to a dedicated planner screen.

## Header Context
- Show the selected currency in a collapsed card (reuse carousel styling if possible) with current sell price and trend.
- Allow changing the currency via dropdown or a mini carousel.

## Core Inputs
1. **Threshold**
   - Slider or numeric input: “Avisar quando o valor de venda estiver abaixo de ___”.
   - Pre-fill with current sell price; enforce locale currency formatting.
2. **Schedule**
   - Datetime picker: “Vigente a partir de”.
   - Make it explicit alerts won’t trigger before this timestamp.
3. **Frequency**
   - Toggle: “Alertar apenas uma vez” vs “Repetir diariamente enquanto estiver abaixo”.

## Validation / UX
- Surface last known quote + trend so users set realistic thresholds.
- Disable scheduling if no cached quote for the selected currency.
- Show a confirmation summary card (e.g., “Avisaremos quando USD venda < R$ 4,90 após 10/12 09:00”).

## Local Notification Hook
- Persist alerts (currency code, threshold, start datetime, repeat flag, status) in a new store/module.
- Use `flutter_local_notifications` + background fetch/periodic worker to poll Banco Central PTAX once the scheduled datetime has passed.
- When a fetch finds `sellPrice < threshold`, fire a notification (“USD caiu para R$ 4,88 (abaixo do seu limite)”).
- After firing, mark alert as completed or reschedule if repeating.

## Alert List
- Same screen or secondary tab lists active/past alerts with status, last check timestamp, edit/cancel actions.
- Keep UI consistent with existing gradients while ensuring the module remains isolated from core dashboard logic.
