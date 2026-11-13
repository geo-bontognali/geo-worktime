// geo-worktime config. Copy to config.js (gitignored).
// A customer is recognised when its code shows up in a window title as a word of its own, in capitals:
// "[WSF-662] …", "BET Bettermann - Backlog - Jira", "Chat | SQB - MS-Apps". Only the codes listed here count,
// so other capitals in titles (MDA, ERD, API, PDF) never turn into customers. Everything else is "?".
// What follows a code counts for that customer until another code shows up, at most 2 h after it was last seen.
// Customers created from the page (right-click → new code) land in customers.json, not here.
window.WORKTIME_CONFIG = {
    // code = Jira project key, name = shown next to it, color = Catppuccin name or hex (fixed, so it is the same every day;
    // without one a colour is derived from the code).
    customers: [
        { code: 'BET', name: 'Bettermann',             color: 'blue' },
        { code: 'CAP', name: 'Capelli Report App',     color: 'teal' },
        { code: 'DAY', name: 'Dayton Advisors',        color: 'pink' },
        { code: 'ERN', name: 'ERNE AG',                color: 'sky' },
        { code: 'FJF', name: 'Franz Fischer',          color: 'peach' },
        { code: 'ORE', name: 'OreaAI',                 color: 'yellow' },
        { code: 'ROC', name: 'Roche',                  color: 'sky' },
        { code: 'SQB', name: 'Systemberater',          color: 'flamingo' },
        { code: 'STV', name: 'Stradivini',             color: 'rosewater' },
        { code: 'SUB', name: 'Subscryption',           color: 'maroon' },
        { code: 'SWZ', name: 'Kanton Schwyz',          color: 'maroon' },
        { code: 'SZG', name: 'Stadt Zug',              color: 'flamingo' },
        { code: 'TKB', name: 'Thurgauer Kantonalbank', color: 'sapphire' },
        { code: 'WEN', name: 'Wenger Automation',      color: 'teal' },
        { code: 'WSF', name: 'Wirtschaftsschule Five', color: 'mauve' },
        { code: 'ZNX', name: 'Zenix',                  color: 'rosewater' },
        { code: 'ZWF', name: 'Zweifel',                color: 'pink' },
    ],
};
