(function () {
    if (!window.Chart) {
        return;
    }

    var CORES = {
        serie: '#2e8b30',
        concluiram: '#12460b',
        emAndamento: '#5f9a55',
        naoIniciaram: '#a3b79e',
        grade: '#e3ece1',
        texto: '#5f6b5c',
        superficie: '#ffffff'
    };

    Chart.defaults.font.family = "'Poppins', 'Segoe UI', system-ui, sans-serif";
    Chart.defaults.font.size = 12;
    Chart.defaults.color = CORES.texto;
    Chart.defaults.maintainAspectRatio = false;
    Chart.defaults.plugins.tooltip.backgroundColor = '#1f2a1d';
    Chart.defaults.plugins.tooltip.padding = 10;
    Chart.defaults.plugins.tooltip.cornerRadius = 8;
    Chart.defaults.plugins.tooltip.displayColors = true;

    function ler(id) {
        var elemento = document.getElementById(id);
        return elemento ? JSON.parse(elemento.textContent) : null;
    }

    function eixoContagem() {
        return {
            beginAtZero: true,
            ticks: { precision: 0 },
            grid: { color: CORES.grade },
            border: { display: false }
        };
    }

    function eixoCategorias() {
        return {
            grid: { display: false },
            border: { color: CORES.grade }
        };
    }

    function barrasDeCashs(idCanvas, idDados) {
        var canvas = document.getElementById(idCanvas);
        var dados = ler(idDados);
        if (!canvas || !dados) {
            return;
        }
        new Chart(canvas, {
            type: 'bar',
            data: {
                labels: dados.rotulos,
                datasets: [{
                    label: 'Cashs',
                    data: dados.valores,
                    backgroundColor: CORES.serie,
                    borderRadius: 4,
                    borderSkipped: 'start',
                    maxBarThickness: 24
                }]
            },
            options: {
                indexAxis: 'y',
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function (contexto) { return contexto.parsed.x + ' Cashs'; }
                        }
                    }
                },
                scales: { x: eixoContagem(), y: eixoCategorias() }
            }
        });
    }

    function situacaoPorModulo(idCanvas, idDados) {
        var canvas = document.getElementById(idCanvas);
        var dados = ler(idDados);
        if (!canvas || !dados) {
            return;
        }
        function segmento(rotulo, valores, cor) {
            return {
                label: rotulo,
                data: valores,
                backgroundColor: cor,
                borderColor: CORES.superficie,
                borderWidth: { top: 0, right: 2, bottom: 0, left: 0 },
                borderSkipped: false,
                maxBarThickness: 24
            };
        }
        new Chart(canvas, {
            type: 'bar',
            data: {
                labels: dados.rotulos,
                datasets: [
                    segmento('Concluíram', dados.concluiram, CORES.concluiram),
                    segmento('Em andamento', dados.em_andamento, CORES.emAndamento),
                    segmento('Não iniciaram', dados.nao_iniciaram, CORES.naoIniciaram)
                ]
            },
            options: {
                indexAxis: 'y',
                plugins: {
                    legend: {
                        position: 'top',
                        align: 'start',
                        labels: { boxWidth: 12, boxHeight: 12, useBorderRadius: true, borderRadius: 2 }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (contexto) {
                                var quantidade = contexto.parsed.x;
                                return contexto.dataset.label + ': ' + quantidade + (quantidade === 1 ? ' aluno' : ' alunos');
                            }
                        }
                    }
                },
                scales: {
                    x: Object.assign(eixoContagem(), { stacked: true }),
                    y: Object.assign(eixoCategorias(), { stacked: true })
                }
            }
        });
    }

    function cadastrosPorMes(idCanvas, idDados) {
        var canvas = document.getElementById(idCanvas);
        var dados = ler(idDados);
        if (!canvas || !dados) {
            return;
        }
        new Chart(canvas, {
            type: 'bar',
            data: {
                labels: dados.rotulos,
                datasets: [{
                    label: 'Cadastros',
                    data: dados.valores,
                    backgroundColor: CORES.serie,
                    borderRadius: 4,
                    borderSkipped: 'start',
                    maxBarThickness: 24
                }]
            },
            options: {
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function (contexto) {
                                var quantidade = contexto.parsed.y;
                                return quantidade + (quantidade === 1 ? ' cadastro' : ' cadastros');
                            }
                        }
                    }
                },
                scales: { x: eixoCategorias(), y: eixoContagem() }
            }
        });
    }

    barrasDeCashs('grafico-cashs', 'dados-cashs');
    situacaoPorModulo('grafico-conclusao', 'dados-conclusao');
    cadastrosPorMes('grafico-cadastros', 'dados-cadastros');
})();
