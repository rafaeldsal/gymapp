import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { of, throwError, asyncScheduler } from 'rxjs';
import { observeOn } from 'rxjs/operators';
import { AppComponent } from './app.component';
import { ApiService } from './services/api.service';

// Mock do ApiService usando Jest
const mockApiService = {
  getHealth: jest.fn(),
  testStudents: jest.fn()
};

describe('AppComponent', () => {
  let component: AppComponent;
  let fixture: ComponentFixture<AppComponent>;
  let apiService: jest.Mocked<ApiService>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AppComponent],
      providers: [
        { provide: ApiService, useValue: mockApiService }
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(AppComponent);
    component = fixture.componentInstance;
    apiService = TestBed.inject(ApiService) as jest.Mocked<ApiService>;

    // Resetar mocks antes de cada teste
    jest.clearAllMocks();
  });

  it('should create the app', () => {
    expect(component).toBeTruthy();
  });

  it('should have initial empty apiResponse and apiError', () => {
    expect(component.apiResponse).toBe('');
    expect(component.apiError).toBe('');
  });

  it('should call ApiService.getHealth and update apiResponse immediately', fakeAsync(() => {
    // Usar observeOn para tornar o Observable assíncrono
    apiService.getHealth.mockReturnValue(
      of('API is running! 🏋️').pipe(observeOn(asyncScheduler))
    );

    component.testHealth();

    // Verifica o valor inicial IMEDIATAMENTE após a chamada
    expect(component.apiResponse).toBe('Testando...');
    expect(apiService.getHealth).toHaveBeenCalled();

    // Avança o tempo para completar a assincronicidade
    tick();

    // Agora verifica o valor final
    expect(component.apiResponse).toBe('API is running! 🏋️');
  }));

  it('should update apiResponse when getHealth succeeds', fakeAsync(() => {
    apiService.getHealth.mockReturnValue(
      of('API is running! 🏋️').pipe(observeOn(asyncScheduler))
    );

    component.testHealth();

    // Verifica o valor inicial
    expect(component.apiResponse).toBe('Testando...');

    // Avança o tempo para completar a assincronicidade
    tick();

    expect(component.apiResponse).toBe('API is running! 🏋️');
    expect(component.apiError).toBe('');
  }));

  it('should call ApiService.testStudents and update apiResponse', fakeAsync(() => {
    apiService.testStudents.mockReturnValue(
      of('Students endpoint working!').pipe(observeOn(asyncScheduler))
    );

    component.testStudents();

    // Verifica o valor inicial
    expect(apiService.testStudents).toHaveBeenCalled();
    expect(component.apiResponse).toBe('Testando students...');

    // Avança o tempo
    tick();

    // Verifica o valor final
    expect(component.apiResponse).toBe('Students endpoint working!');
  }));

  it('should handle API errors for getHealth', fakeAsync(() => {
    const errorMessage = 'Network error';
    apiService.getHealth.mockReturnValue(
      throwError(() => new Error(errorMessage)).pipe(observeOn(asyncScheduler))
    );

    component.testHealth();

    // Verifica o valor inicial
    expect(component.apiResponse).toBe('Testando...');

    // Avança o tempo
    tick();

    expect(component.apiError).toBe('Erro ao conectar com a API: ' + errorMessage);
  }));

  it('should handle API errors for testStudents', fakeAsync(() => {
    const errorMessage = 'Students API error';
    apiService.testStudents.mockReturnValue(
      throwError(() => new Error(errorMessage)).pipe(observeOn(asyncScheduler))
    );

    component.testStudents();

    // Verifica o valor inicial
    expect(component.apiResponse).toBe('Testando students...');

    // Avança o tempo
    tick();

    expect(component.apiError).toBe('Erro ao conectar com Students API: ' + errorMessage);
  }));

  it('should clear previous errors when making new successful call', fakeAsync(() => {
    // Primeiro um erro
    apiService.getHealth.mockReturnValue(
      throwError(() => new Error('First error')).pipe(observeOn(asyncScheduler))
    );
    component.testHealth();
    tick();

    expect(component.apiError).not.toBe('');

    // Depois um sucesso
    apiService.getHealth.mockReturnValue(
      of('Success!').pipe(observeOn(asyncScheduler))
    );
    component.testHealth();

    // Verifica que o erro foi limpo e o placeholder foi setado
    expect(component.apiError).toBe('');
    expect(component.apiResponse).toBe('Testando...');

    tick();

    expect(component.apiResponse).toBe('Success!');
  }));
});