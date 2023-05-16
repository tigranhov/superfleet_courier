part of 'api.dart';

class DioMock extends InterceptorsWrapper {
  //
  // DioMock(Dio dio){
  //   adapter.onGet('/auth/me', (server) {
  //     server.reply(200, map['/auth/me']);
  //   });
  //   adapter.onGet('/orders/courier/17', (server) {
  //     server.reply(200, map['/orders/courier/17']);
  //   });
  //   adapter.onGet('/orders/15', (server) {
  //     server.reply(200, map['/orders/15']);
  //   });
  //
  //   adapter.onPatch('/orders/15', (server) {
  //     server.reply(200, map['/orders/15']);
  //     print('objec kalbast');
  //   });
  // }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;
    if (options.method == 'PATCH') {
      map[path]['data'].addAll(options.data);
      map['/orders/courier/17']['data']['items'][0].addAll(options.data);
    }
    handler.resolve(
      Response(
        requestOptions: options,
        data: map[path],
        statusCode: 200,
      ),
    );
    // super.onRequest(options, handler);
  }
}

final map = {
  '/auth/me': {
    'data': {
      'id': 17,
      'email': "ketchup@gmail.com",
      'roles': ['USER'],
      'isAccountDisabled': false,
      'firstName': "Vaxo",
      'lastName': "Patveryan",
      'profileImageId': null,
      'status': "ACTIVE",
      'transport': "CAR",
      'location': {
        'name': "string",
        'address': "string",
        'country': "string",
        'province': "string",
        'locality': "string",
        'provider': "string",
        'street': "string",
        'house': "string",
        'lat': 40.176926,
        'lng': 44.49703,
        'alt': 0
      },
      'createdAt': "2022-12-02T18:57:54.481Z",
      'updatedAt': "2023-05-15T22:48:02.305Z",
      'deletedAt': null
    },
    'meta': {}
  },
  '/orders/courier/17': jsonDecode('''{
    "data": {
        "items": [
            {
                "id": 15,
                "status": "OPEN",
                "courier": {
                    "id": 17,
                    "email": "ketchup@gmail.com",
                    "roles": [
                        "USER"
                    ],
                    "isAccountDisabled": false,
                    "firstName": "Vaxo",
                    "lastName": "Patveryan",
                    "profileImageId": null,
                    "status": "ACTIVE",
                    "transport": "CAR",
                    "location": {
                        "name": "string",
                        "address": "string",
                        "country": "string",
                        "province": "string",
                        "locality": "string",
                        "provider": "string",
                        "street": "string",
                        "house": "string",
                        "lat": 40.176926,
                        "lng": 44.49703,
                        "alt": 0
                    },
                    "createdAt": "2022-12-02T18:57:54.481Z",
                    "updatedAt": "2023-05-15T22:48:02.305Z",
                    "deletedAt": null
                },
                "from": [
                    {
                        "id": 17,
                        "location": {
                            "lat": 40.212747,
                            "lng": 44.482767
                        },
                        "pickedUp": false,
                        "availableFrom": "2022-09-21T08:27:41.089Z"
                    }
                ],
                "to": {
                    "id": 16,
                    "location": {
                        "lat": 40.13352007310614,
                        "lng": 44.51439033471284
                    }
                },
                "deliverUntil": "2022-09-21T08:27:41.089Z",
                "createdAt": "2022-09-21T08:31:29.084Z",
                "updatedAt": "2023-05-10T12:19:07.879Z",
                "deletedAt": null
            },
            {
                "id": 16,
                "status": "OPEN",
                "courier": {
                    "id": 17,
                    "email": "ketchup@gmail.com",
                    "roles": [
                        "USER"
                    ],
                    "isAccountDisabled": false,
                    "firstName": "Vaxo",
                    "lastName": "Patveryan",
                    "profileImageId": null,
                    "status": "ACTIVE",
                    "transport": "CAR",
                    "location": {
                        "name": "string",
                        "address": "string",
                        "country": "string",
                        "province": "string",
                        "locality": "string",
                        "provider": "string",
                        "street": "string",
                        "house": "string",
                        "lat": 40.176926,
                        "lng": 44.49703,
                        "alt": 0
                    },
                    "createdAt": "2022-12-02T18:57:54.481Z",
                    "updatedAt": "2023-05-15T22:48:02.305Z",
                    "deletedAt": null
                },
                "from": [
                    {
                        "id": 18,
                        "location": {
                            "lat": 40.191105,
                            "lng": 44.474889
                        },
                        "pickedUp": false,
                        "availableFrom": "2022-10-20T05:32:28.195Z"
                    }
                ],
                "to": {
                    "id": 17,
                    "location": {
                        "lat": 40.19317650409632,
                        "lng": 44.4900144191855
                    }
                },
                "deliverUntil": "2022-10-20T05:32:28.195Z",
                "createdAt": "2022-10-20T05:33:27.190Z",
                "updatedAt": "2023-05-10T12:19:16.876Z",
                "deletedAt": null
            }
        ],
        "offset": 0,
        "limit": 100,
        "totalItems": 2,
        "moreItems": false
    },
    "meta": {}
}'''),
  '/orders/15': jsonDecode(
      '''{"data":{"id":15,"status":"OPEN","courier":{"id":17,"email":"ketchup@gmail.com","roles":["USER"],"isAccountDisabled":false,"firstName":"Vaxo","lastName":"Patveryan","profileImageId":null,"status":"ACTIVE","transport":"CAR","location":{"name":"string","address":"string","country":"string","province":"string","locality":"string","provider":"string","street":"string","house":"string","lat":40.176926,"lng":44.49703,"alt":0},"createdAt":"2022-12-02T18:57:54.481Z","updatedAt":"2023-05-15T22:48:02.305Z","deletedAt":null},"from":[{"id":17,"location":{"lat":40.212747,"lng":44.482767},"pickedUp":false,"availableFrom":"2022-09-21T08:27:41.089Z"}],"to":{"id":16,"location":{"lat":40.13352007310614,"lng":44.51439033471284}},"deliverUntil":"2022-09-21T08:27:41.089Z","createdAt":"2022-09-21T08:31:29.084Z","updatedAt":"2023-05-10T12:19:07.879Z","deletedAt":null},"meta":{}}''')
};
