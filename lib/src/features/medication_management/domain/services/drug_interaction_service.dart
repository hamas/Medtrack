import '../entities/medicine.dart';

class DrugInteraction {
  const DrugInteraction({
    required this.drug1,
    required this.drug2,
    required this.severity,
    required this.title,
    required this.description,
    required this.recommendation,
  });

  final String drug1;
  final String drug2;
  final String severity; // 'High', 'Moderate', 'Severe'
  final String title;
  final String description;
  final String recommendation;
}

class DrugInteractionService {
  DrugInteractionService._();

  static final List<
    ({List<String> groupA, List<String> groupB, DrugInteraction interaction})
  >
  _knownInteractions = <({List<String> groupA, List<String> groupB, DrugInteraction interaction})>[
    // 1. Anticoagulants + NSAIDs -> Severe bleeding risk
    (
      groupA: <String>[
        'warfarin',
        'heparin',
        'apixaban',
        'eliquis',
        'rivaroxaban',
        'xarelto',
        'aspirin',
        'clopidogrel',
        'plavix',
        'dabigatran',
      ],
      groupB: <String>[
        'ibuprofen',
        'advil',
        'motrin',
        'naproxen',
        'aleve',
        'diclofenac',
        'voltaren',
        'meloxicam',
        'ketorolac',
        'celecoxib',
        'celebrex',
      ],
      interaction: const DrugInteraction(
        drug1: 'Anticoagulant / Antiplatelet',
        drug2: 'NSAID (Anti-inflammatory)',
        severity: 'High',
        title: 'Elevated Hemorrhage Risk',
        description:
            'Combining blood thinners with NSAIDs substantially increases the risk of upper gastrointestinal bleeding and peptic ulceration.',
        recommendation:
            'Consult your physician before combining. Consider acetaminophen (paracetamol) for pain relief as an alternative.',
      ),
    ),

    // 2. ACE Inhibitors / ARBs + Potassium-sparing agents -> Hyperkalemia
    (
      groupA: <String>[
        'lisinopril',
        'enalapril',
        'ramipril',
        'losartan',
        'valsartan',
        'candesartan',
        'irbesartan',
      ],
      groupB: <String>[
        'spironolactone',
        'aldactone',
        'eplerenone',
        'potassium',
        'k-dur',
        'klor-con',
        'triamterene',
      ],
      interaction: const DrugInteraction(
        drug1: 'ACE-Inhibitor / ARB',
        drug2: 'Potassium Agent / Aldosterone Blocker',
        severity: 'High',
        title: 'Hyperkalemia Risk',
        description:
            'Concomitant administration can impair renal potassium excretion, leading to potentially dangerous hyperkalemia and cardiac dysrhythmias.',
        recommendation:
            'Requires serum potassium and creatinine monitoring by your healthcare provider.',
      ),
    ),

    // 3. Fluoroquinolones / Tetracyclines + Calcium / Dairy / Iron -> Chelation
    (
      groupA: <String>[
        'ciprofloxacin',
        'cipro',
        'levofloxacin',
        'levaquin',
        'doxycycline',
        'tetracycline',
        'minocycline',
      ],
      groupB: <String>[
        'calcium',
        'iron',
        'ferrous',
        'antacid',
        'magnesium',
        'tums',
        'pepto',
      ],
      interaction: const DrugInteraction(
        drug1: 'Antibiotic (Quinolone/Tetracycline)',
        drug2: 'Cation Supplement (Calcium/Iron/Antacid)',
        severity: 'Moderate',
        title: 'Absorption Chelation Inhibition',
        description:
            'Polyvalent metallic cations (calcium, magnesium, iron) form insoluble chelates with these antibiotics, reducing oral bioavailability by up to 80%.',
        recommendation:
            'Space dosing at least 2 hours before or 4 hours after cation-containing meals or supplements.',
      ),
    ),

    // 4. SSRIs / SNRIs + Tramadol / MAOIs -> Serotonin Syndrome
    (
      groupA: <String>[
        'sertraline',
        'zoloft',
        'fluoxetine',
        'prozac',
        'escitalopram',
        'lexapro',
        'citalopram',
        'celexa',
        'duloxetine',
        'cymbalta',
        'venlafaxine',
        'effexor',
      ],
      groupB: <String>[
        'tramadol',
        'ultram',
        'linezolid',
        'selegiline',
        'phenelzine',
        'st john',
        'hypericum',
      ],
      interaction: const DrugInteraction(
        drug1: 'SSRI / SNRI Antidepressant',
        drug2: 'Serotonergic Analgesic / MAOI',
        severity: 'High',
        title: 'Serotonin Syndrome Potential',
        description:
            'Additive serotonergic neurotransmission can induce toxic serotonin toxicity: hyperreflexia, tremors, fever, and autonomic instability.',
        recommendation:
            'Do not co-administer without direct specialist supervision.',
      ),
    ),

    // 5. Statins + Strong CYP3A4 inhibitors
    (
      groupA: <String>[
        'atorvastatin',
        'lipitor',
        'simvastatin',
        'zocor',
        'lovastatin',
      ],
      groupB: <String>[
        'clarithromycin',
        'erythromycin',
        'ketoconazole',
        'itraconazole',
        'diltiazem',
      ],
      interaction: const DrugInteraction(
        drug1: 'HMG-CoA Reductase Inhibitor (Statin)',
        drug2: 'CYP3A4 Inhibitor',
        severity: 'High',
        title: 'Statin Toxicity & Rhabdomyolysis',
        description:
            'Inhibition of cytochrome P450 3A4 metabolism dramatically increases systemic statin levels, multiplying risk of myopathy and acute kidney injury.',
        recommendation:
            'Statins may need temporary suspension during antibiotic or antifungal courses.',
      ),
    ),

    // 6. Nitrates + PDE5 inhibitors -> Fatal Hypotension
    (
      groupA: <String>[
        'nitroglycerin',
        'nitrostat',
        'isosorbide',
        'imdur',
        'monoket',
      ],
      groupB: <String>[
        'sildenafil',
        'viagra',
        'revatio',
        'tadalafil',
        'cialis',
        'vardenafil',
      ],
      interaction: const DrugInteraction(
        drug1: 'Organic Nitrate (Vasodilator)',
        drug2: 'PDE-5 Inhibitor',
        severity: 'Severe',
        title: 'Severe Refractory Hypotension',
        description:
            'Synergistic elevation of cyclic GMP produces profound systemic vasodilation, precipitating acute coronary or cerebral ischemia.',
        recommendation:
            'Strictly contraindicated. Maintain at least 24-48 hours separation.',
      ),
    ),

    // 7. CNS Depressants (Opioids + Benzodiazepines)
    (
      groupA: <String>[
        'oxycodone',
        'percocet',
        'hydrocodone',
        'vicodin',
        'morphine',
        'codeine',
        'fentanyl',
        'methadone',
      ],
      groupB: <String>[
        'alprazolam',
        'xanax',
        'diazepam',
        'valium',
        'lorazepam',
        'ativan',
        'clonazepam',
        'klonopin',
        'zolpidem',
        'ambien',
      ],
      interaction: const DrugInteraction(
        drug1: 'Opioid Analgesic',
        drug2: 'Sedative / Benzodiazepine',
        severity: 'High',
        title: 'Profound Respiratory Depression',
        description:
            'Combined central nervous system suppression causes synergistic respiratory depression, profound sedation, coma, or respiratory arrest.',
        recommendation:
            'FDA Black Box Warning: strictly limit concurrent use to minimal effective doses.',
      ),
    ),
  ];

  /// Checks if [newDrugName] interacts with any of the existing active [cabinetDrugs].
  static List<DrugInteraction> checkInteractions({
    required String newDrugName,
    required List<Medicine> cabinetDrugs,
    DeliveryMethod? deliveryMethod,
  }) {
    final List<DrugInteraction> found = <DrugInteraction>[];
    final String target = newDrugName.toLowerCase().trim();

    // Special check: Quinolone/Tetracycline taken with milk
    if (deliveryMethod == DeliveryMethod.milk) {
      final bool isQuinoloneOrTetra = <String>[
        'ciprofloxacin',
        'cipro',
        'levofloxacin',
        'levaquin',
        'doxycycline',
        'tetracycline',
      ].any((String k) => target.contains(k));

      if (isQuinoloneOrTetra) {
        found.add(
          const DrugInteraction(
            drug1: 'Antibiotic',
            drug2: 'Milk / Dairy (Delivery method)',
            severity: 'Moderate',
            title: 'Calcium-Binding Absorption Block',
            description:
                'Calcium in milk and dairy binds directly to this antibiotic in the digestive tract, rendering it unabsorbable.',
            recommendation:
                'Take with water instead of milk, and avoid dairy for 2 hours before and after administration.',
          ),
        );
      }
    }

    for (final Medicine med in cabinetDrugs) {
      if (!med.isActive) continue;
      final String existing = med.name.toLowerCase().trim();

      for (final ({
            List<String> groupA,
            List<String> groupB,
            DrugInteraction interaction,
          })
          rule
          in _knownInteractions) {
        final bool aMatchesTarget = rule.groupA.any(
          (String s) => target.contains(s) || s.contains(target),
        );
        final bool bMatchesExisting = rule.groupB.any(
          (String s) => existing.contains(s) || s.contains(existing),
        );

        final bool bMatchesTarget = rule.groupB.any(
          (String s) => target.contains(s) || s.contains(target),
        );
        final bool aMatchesExisting = rule.groupA.any(
          (String s) => existing.contains(s) || s.contains(existing),
        );

        if ((aMatchesTarget && bMatchesExisting) ||
            (bMatchesTarget && aMatchesExisting)) {
          // Avoid duplicate warnings for the same rule
          if (!found.any(
            (DrugInteraction di) => di.title == rule.interaction.title,
          )) {
            found.add(rule.interaction);
          }
        }
      }
    }

    return found;
  }
}
