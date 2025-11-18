
> Banco Central’s PTAX service splits “Moedas” into two buckets via tipoMoeda:

- Tipo A (código “A”) are the so‑called “main” PTAX currencies: USD, CAD, CHF, DKK, JPY, NOK, SEK, etc. They’re the ones Banco Central quotes daily and uses in FX operations.
- Tipo B (código “B”) are “secondary” currencies (EUR, GBP, AUD, etc.) whose PTAX rates are derived indirectly (via cross‑rates) or quoted less frequently.

What that means for us:

1. Availability & freshness – Tipo A symbols almost always have data in CotacaoMoedaDia/Periodo, while Tipo B might return empty values on some days or only refresh after
   Banco Central updates cross‑rates. In the UI, that argues for:
    - A subtle label in the carousel (badge “A”/“B” or tooltip) so users know why some currencies lag.
    - Different empty/error messaging when a Tipo B rate isn’t available (“Cotação indireta indisponível no momento” vs. the generic error).
2. Ordering / grouping – We can implement a header section that groups cards (e.g., first show Tipo A, then Tipo B), or add filter tabs (“Moedas PTAX” vs. “Cruzas”) so power
   users can focus on the more reliable set.
3. Styling cues – Since cards already use distinct colors, we could add a subtle accent (icon or chip) reflecting Tipo A vs. B without overwhelming the layout. For example, a
   small badge on the card saying “PTAX” or “Cross” or a slight border style difference.
4. Data logic – When fetching history or current quotes, we might want fallback messaging for Tipo B (e.g., retry with last cached quote faster, or display “Última
   atualização: data X (cotação indireta)”). Internally, knowing tipoMoeda could also help prioritize which currencies we prefetch or mark “featured” on the carousel.

Bottom line: the Tipo A/B split explains why some symbols may be less frequent/missing; surfacing it in the UI (all via small labels/tooltips + tailored empty state text)
will make the experience clearer, and we can hook that metadata into our provider so both the presentation and caching logic can adapt accordingly.