import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:dollar_now/service/olinda_service.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  group('OlindaService', () {
    late OlindaService service;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      service = OlindaService(client: mockHttpClient);
    });

    test('fetchCotacaoDolarPeriodo parses correctly', () async {
      const mockResponse = '''{
        "@odata.context": "https://olinda.bcb.gov.br/...",
        "value": [
          {
            "cotacaoCompra": 4.90,
            "cotacaoVenda": 4.91,
            "dataHoraCotacao": "2023-11-01 13:00:00.0"
          },
          {
            "cotacaoCompra": 4.92,
            "cotacaoVenda": 4.93,
            "dataHoraCotacao": "2023-11-02 13:00:00.0"
          }
        ]
      }''';

      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(mockResponse, 200),
      );

      final cotacoes = await service.fetchCotacaoDolarPeriodo(
        dataInicial: '11-01-2023',
        dataFinalCotacao: '11-02-2023'
      );

      expect(cotacoes.length, 2);
      expect(cotacoes[0].cotacaoCompra, 4.90);
      expect(cotacoes[1].cotacaoCompra, 4.92);
    });
  });
}
