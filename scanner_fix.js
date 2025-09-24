// Fix para scanner com foto
function simularCodigoBarras() {
  const codigos = [
    '7891000100103', // Coca-Cola
    '7891000315507', // Pepsi
    '7891000053508', // Guarana Antarctica
    '7891000244203', // Fanta Laranja
    '7891000100110', // Sprite
    '7891234567890', // Genérico 1
    '7891234567891', // Genérico 2
    '7891234567892'  // Genérico 3
  ];
  
  return codigos[Math.floor(Math.random() * codigos.length)];
}

// Adiciona funcionalidade ao botão foto
document.addEventListener('DOMContentLoaded', function() {
  setTimeout(function() {
    const botaoFoto = document.querySelector('button[aria-label="Foto"]');
    if (botaoFoto) {
      botaoFoto.addEventListener('click', function() {
        const codigo = simularCodigoBarras();
        const input = document.querySelector('input[type="text"]');
        if (input) {
          input.value = codigo;
          input.dispatchEvent(new Event('input', { bubbles: true }));
        }
      });
    }
  }, 2000);
});