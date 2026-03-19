# Mobile Build Standards

**Status**: MANDATORY · PIPELINE-BLOCKING
**Applies to**: All build phases and Ralph QA

---

## 1. SUBSCRIPTION & STORE COMPLIANCE

### 1.1 RevenueCat (if monetization enabled)

If the PRD specifies monetization, all subscription handling must use RevenueCat. If the PRD specifies a free app, no monetization code should be present.

- No custom billing logic
- No direct StoreKit / Play Billing usage outside RevenueCat
- No alternative payment processors
- Entitlement-based access control only
- Restore Purchases implemented and visible
- Subscription lifecycle handling: purchase, renewal, expiration, cancellation, billing issues
- Entitlement state is the single source of truth

### 1.2 iOS (Apple App Store)

- Follow current App Store Review Guidelines
- Clearly disclose: price, billing interval, auto-renewal, cancellation method
- Provide Restore Purchases without login
- Link Privacy Policy and Terms of Use in-app
- Provide in-app account deletion if accounts exist
- Include Sign in with Apple if other social logins exist

### 1.3 Android (Google Play)

- Use Play Billing via RevenueCat
- Provide in-app subscription management/cancellation
- Disclose pricing and renewal at point of offer
- Use Android App Bundle (AAB)
- Target current required SDK level

### 1.4 Subscription UX Rules

- All prices readable and visible
- Billing intervals clearly stated
- Trial terms explained in plain language
- Cancellation instructions easy to find
- Clear free vs premium distinction
- No dark patterns, fake urgency, or hidden dismiss paths

---

## 2. PAYWALL UX (if monetization enabled)

### Pricing Presentation

- Show all plans (monthly / annual)
- If showing "effective monthly," also show billed amount
- Readable font sizes and sufficient contrast
- Localized currency formatting

### Value Proposition

- Benefit-focused copy (outcomes > features)
- Social proof only if genuine
- No false scarcity or countdowns

### Legal Disclosure (near the CTA)

- Auto-renewal disclosure
- Cancellation instructions
- Links to Privacy Policy and Terms of Use

### Dismissal

- If freemium → paywall must be dismissible
- Close button visible and tappable (≥44pt)
- No forced loops back into paywall

---

## 3. REVIEW PROMPTS

- iOS: StoreKit review prompt only
- Android: Google In-App Review API only
- No custom dialogs, incentivized reviews, or feature gating behind reviews
- Require ≥3 successful core actions before prompting
- Trigger only after a positive value moment
- Never on first launch or during onboarding
- Must be dismissible without penalty

---

## 4. ACCESSIBILITY & DESIGN (WCAG 2.1 AA)

- Contrast ≥ 4.5:1 (normal text)
- Touch targets: iOS ≥ 44pt, Android ≥ 48dp
- Text scaling up to 200%
- Full VoiceOver / TalkBack support
- Logical focus order
- Full light/dark mode support
- Reduced-motion support
- Clear, simple language

---

## 5. PRIVACY

- Data minimization — no unnecessary identifiers
- Accurate store privacy declarations
- Privacy Policy linked in-app
- ATT prompt only if cross-app tracking exists
- No fingerprinting or hidden tracking
- HTTPS for all network traffic
- Secure storage for tokens
- No hardcoded secrets

---

## 6. PERFORMANCE & OFFLINE

- < 3 seconds to first interactive screen
- 60fps UI interactions
- Efficient memory and battery usage
- Core features usable offline where feasible
- Cached content with graceful degradation
- Clear offline states and retry actions

---

## 7. CONDITIONAL RULES

### Accounts (if implemented)

- Guest-first default
- Sign in with Apple if other social logins exist
- In-app account deletion
- Data export supported

### Social Features (if implemented)

- Moderation systems and reporting mechanisms
- Privacy controls and age-appropriate safeguards

### AI/ML Features (if implemented)

- Bias evaluation and explainable outputs
- Data usage disclosure and opt-out controls

---

## 8. NON-COMPLIANCE

If any mandatory requirement cannot be met:

1. Explicitly state the blocking constraint
2. Propose the least-risk compliant alternative
3. Halt the build

Silent omission or assumption-based compliance is forbidden. Any build that violates store compliance, subscription transparency, accessibility, or privacy is a **FAILED BUILD**, regardless of functionality.
