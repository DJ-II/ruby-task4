function getUniqIdValue() {
  if (window.crypto && typeof window.crypto.randomUUID === "function") {
    return window.crypto.randomUUID();
  }
  return `id-${Date.now()}-${Math.random().toString(36).slice(2)}`;
}

window.getUniqIdValue = getUniqIdValue;

function setupUserSelection() {
  const form = document.getElementById("bulk-users-form");
  if (!form || form.dataset.initialized === "true") return;
  form.dataset.initialized = "true";

  const all = document.getElementById("select-all");
  const boxes = [...form.querySelectorAll(".user-checkbox")];
  const actions = [...form.querySelectorAll(".bulk-action")];
  const countLabel = document.getElementById("selection-count");

  const refresh = () => {
    const selected = boxes.filter(box => box.checked).length;
    all.checked = boxes.length > 0 && selected === boxes.length;
    all.indeterminate = selected > 0 && selected < boxes.length;
    actions.forEach(button => { button.disabled = selected === 0; });
    countLabel.textContent = `${selected} selected`;
  };

  all.addEventListener("change", () => {
    boxes.forEach(box => { box.checked = all.checked; });
    refresh();
  });

  boxes.forEach(box => box.addEventListener("change", refresh));
  refresh();

  if (window.bootstrap) {
    form.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(element => {
      window.bootstrap.Tooltip.getOrCreateInstance(element);
    });
  }
}

document.addEventListener("DOMContentLoaded", setupUserSelection);
document.addEventListener("turbo:load", setupUserSelection);
