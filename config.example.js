// geo-worktime config. Copy to config.js (gitignored) or run ./setup.sh to generate it.
// Everything is optional. Without this file the page still works, but only the customers
// you set by hand (right-click a block) are known, and no AI call is ever made.
window.WORKTIME_CONFIG = {
    // Customers in display order. code = Jira project key. color = Catppuccin name or hex. match = case-insensitive
    // substrings tested against "title | class"; write '/…/' for a regex. Longest match wins.
    customers: [
        { code: 'BET', name: 'Bettermann',             match: ['bettermann', 'bet-', 'bet -', 'logistics', 'tourenplanung', 'spedition', 'picking list'], color: 'blue' },
        { code: 'CAP', name: 'Capelli Report App',     match: ['capelli'], color: 'teal' },
        { code: 'DAY', name: 'Dayton Advisors',        match: ['dayton'], color: 'pink' },
        { code: 'ERN', name: 'ERNE AG',                match: ['erne'], color: 'sky' },
        { code: 'FJF', name: 'Franz Fischer',          match: ['fischer', 'family office', 'fjf'], color: 'peach' },
        { code: 'ORE', name: 'OreaAI',                 match: ['orea', 'hbt-isol'], color: 'yellow' },
        { code: 'ROC', name: 'Roche',                  match: ['roche'], color: 'sky' },
        { code: 'SQB', name: 'Systemberater',          match: ['systemberater'], color: 'flamingo' },
        { code: 'STV', name: 'Stradivini',             match: ['stradivini'], color: 'rosewater' },
        { code: 'SUB', name: 'Subscryption',           match: ['subscryption'], color: 'maroon' },
        { code: 'SWZ', name: 'Kanton Schwyz',          match: ['schwyz'], color: 'maroon' },
        { code: 'SZG', name: 'Stadt Zug',              match: ['stadt zug'], color: 'flamingo' },
        { code: 'TKB', name: 'Thurgauer Kantonalbank', match: ['/\\btkb\\b/', 'thurgauer'], color: 'sapphire' },
        { code: 'WEN', name: 'Wenger Automation',      match: ['wenger'], color: 'teal' },
        { code: 'WSF', name: 'Wirtschaftsschule Five', match: ['/\\bwsf\\b/', 'wsf-', 'wirtschaftsschule', 'agentic automation'], color: 'mauve' },
        { code: 'ZNX', name: 'Zenix',                  match: ['zenix'], color: 'rosewater' },
        { code: 'ZWF', name: 'Zweifel',                match: ['zweifel'], color: 'pink' },
    ],
    // Internal work: one bucket (INT). Jira keys of internal projects + keywords.
    internal: { name: 'Workframe', jira: ['DEV', 'FIN', 'IT', 'LGL', 'MGT', 'MKT', 'PPL', 'SAL'],
                match: ['workframe', 'abaninja', 'zeiterfassung', 'worklogs - jira', 'geo-worktime', 'geo-corrector', 'pitchdeck'] },
    // Never counted as work (drawn as unassigned, excluded from the copy block).
    ignore: ['music.youtube', 'spotify', 'keeper', 'youtube'],
    // Background for the AI. Short; sent with every classification call.
    context: 'Power Platform / .NET consultant at Workframe AG (Swiss agency). kitty window titles are Claude Code ' +
             'session names describing the task. BET: logistics/Tourenplanung Power Apps, repo bet-logistics, Spedition. ' +
             'WSF: wsf-workframe repo, Agentic Automation, Smith approval app. FJF: Digital Family Office on Azure, fo.fischer.ch. ' +
             'ORE: HBT-ISOL on-prem access. MDA = model-driven app.',
    // Optional. Azure OpenAI Responses API; same values as geo-corrector. Remove to disable AI.
    ai: {
        endpoint: 'https://<resource>.services.ai.azure.com/openai/v1/',
        apiKey: '<key>',
        model: 'gpt-5.4',
        // reasoningEffort: 'none',
    },
    // Learned assignments copied with S land here (title key -> code). Takes precedence over keywords.
    rules: {
        // 'mda to code app migration | kitty': 'BET',
    },
};
