#!/bin/bash
set -e

# Saleor SvelteKit Storefront - Development CLI
# Usage: ./dev.sh [command] [environment]

COMMAND=${1:-help}
ENV=${2:-development}

show_help() {
    echo "🌐 Saleor SvelteKit Storefront - Development CLI"
    echo ""
    echo "Usage: ./dev.sh [command] [environment]"
    echo ""
    echo "Commands:"
    echo "  start [env]     - Start development server"
    echo "  docker [env]    - Start in Docker"
    echo "  build [env]     - Build for production"
    echo "  test [env]      - Run tests"
    echo "  stop [env]      - Stop Docker containers"
    echo "  logs [env]      - Show Docker logs"
    echo "  status          - Show Docker container status"
    echo "  clean           - Clean Docker containers and images"
    echo "  help            - Show this help"
    echo ""
    echo "Environments:"
    echo "  development     - Local development (default)"
    echo "  production      - Production build"
    echo "  test            - Testing environment"
    echo ""
    echo "Examples:"
    echo "  ./dev.sh start                    # Start local dev server"
    echo "  ./dev.sh docker development       # Start dev Docker container"
    echo "  ./dev.sh docker production        # Start prod Docker container"
    echo "  ./dev.sh test                     # Run tests"
    echo "  ./dev.sh build production         # Build for production"
}

start_local() {
    echo "🚀 Starting local development server ($ENV)..."
    case $ENV in
        development)
            pnpm run dev:local
            ;;
        production)
            pnpm run build:production && pnpm run start
            ;;
        test)
            pnpm run build:test && pnpm run start
            ;;
        *)
            echo "❌ Unknown environment: $ENV"
            exit 1
            ;;
    esac
}

start_docker() {
    echo "🐳 Starting Docker containers ($ENV)..."
    ./deploy.sh $ENV
}

build_project() {
    echo "🏗️  Building project ($ENV)..."
    case $ENV in
        development)
            pnpm run build:development
            ;;
        production)
            pnpm run build:production
            ;;
        test)
            pnpm run build:test
            ;;
        *)
            echo "❌ Unknown environment: $ENV"
            exit 1
            ;;
    esac
}

run_tests() {
    echo "🧪 Running tests ($ENV)..."
    case $ENV in
        local)
            pnpm run test:local
            ;;
        docker)
            pnpm run test:docker
            ;;
        *)
            pnpm run test
            ;;
    esac
}

stop_containers() {
    echo "🛑 Stopping Docker containers ($ENV)..."
    ./stop.sh $ENV
}

show_logs() {
    echo "📝 Showing Docker logs ($ENV)..."
    ./logs.sh $ENV
}

show_status() {
    echo "📊 Checking Docker status..."
    ./status.sh
}

clean_docker() {
    echo "🧹 Cleaning Docker containers and images..."
    docker system prune -f
    echo "✅ Docker cleanup complete!"
}

case $COMMAND in
    start)
        start_local
        ;;
    docker)
        start_docker
        ;;
    build)
        build_project
        ;;
    test)
        run_tests
        ;;
    stop)
        stop_containers
        ;;
    logs)
        show_logs
        ;;
    status)
        show_status
        ;;
    clean)
        clean_docker
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ Unknown command: $COMMAND"
        echo ""
        show_help
        exit 1
        ;;
esac
