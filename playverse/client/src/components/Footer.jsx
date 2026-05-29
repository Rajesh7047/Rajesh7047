export default function Footer() {
  return (
    <footer className="pv-footer mt-auto py-4">
      <div className="pv-container text-center text-muted small">
        <p className="mb-1">
          <strong className="text-white">PlayVerse</strong> — Browse, purchase &amp; install PC games
        </p>
        <p className="mb-0">BCA Project · React · Node.js · MongoDB</p>
      </div>
      <style>{`
        .pv-footer { border-top: 1px solid var(--pv-border); background: var(--pv-surface); }
      `}</style>
    </footer>
  );
}
