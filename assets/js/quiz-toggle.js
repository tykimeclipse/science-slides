document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".quiz").forEach((el) => {
    el.addEventListener("click", () => {
      el.classList.toggle("revealed");
    });
  });
});
