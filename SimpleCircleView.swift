import SwiftUI

struct SimpleCircleView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Círculo de Prueba")
                .font(.headline)
            
            Circle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
            
            Circle()
                .fill(Color.red)
                .frame(width: 100, height: 100)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    SimpleCircleView()
}
