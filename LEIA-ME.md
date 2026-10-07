# Scanner de ambiente (RoomPlan) — como plugar

## Requisitos
- Xcode com `RoomPlan` (iOS 16+)
- Aparelho físico com **LiDAR** (RoomPlan não funciona no simulador nem em
  iPhones sem LiDAR — linha "Pro" a partir do iPhone 12, ou iPad Pro 2020+)
- `Info.plist`: adicionar `NSCameraUsageDescription` (o RoomPlan usa a câmera)

## Arquivos
- **`RoomScannerView.swift`** — a tela de escaneamento em si (câmera + overlay do RoomPlan).
- **`DomusScanUploader.swift`** — pega o resultado (`CapturedRoom`) e manda pro
  backend em `POST /homes/{home_id}/rooms/scan`.

## Fluxo completo
1. Usuário abre "Escanear novo ambiente" no app.
2. `RoomScannerView` guia o escaneamento (o próprio RoomPlan desenha o overlay).
3. Ao concluir, `onFinish(capturedRoom)` dispara.
4. `DomusScanUploader.upload(...)` extrai o contorno do piso e envia pro backend.
5. O backend cria o ambiente, com sensores padrão (presença + temperatura), e
   avisa por WebSocket — a planta 2D/3D atualiza sozinha, sem reload.

## Limitações atuais (documentadas de propósito)
- **Forma**: o backend simplifica qualquer contorno para o retângulo que o
  envolve (bounding box), porque o front-end hoje só desenha retângulos. O
  contorno original fica salvo no MongoDB (`room_scans`), pronto para quando
  o 2D/3D passar a desenhar polígonos de verdade.
- **Portas e janelas**: o RoomPlan já detecta isso (`room.doors`,
  `room.windows`), mas ainda não estamos enviando — é o próximo passo natural
  depois que o formato de sala irregular estiver resolvido.
- **Móveis**: o RoomPlan também detecta objetos (`room.objects`), não usado ainda.
- **Android**: sem equivalente nativo pronto; ficaria pra uma fase futura com
  ARCore + Depth API ou um SDK comercial (Polycam, Matterport).
